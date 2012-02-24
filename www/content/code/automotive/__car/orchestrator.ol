include "runtime.iol"
include "console.iol"
include "string_utils.iol"

include "../config/config.iol"
include "./public/interfaces/OrchestratorInterface.iol"
include "./public/interfaces/CarPrivateInterface.iol"
include "../__garages/public/surfaces/AggregatorSurface.iol"
include "../__rental/public/interfaces/RentalInterface.iol"
include "../__trucks/public/interfaces/TruckInterface.iol"
include "../__register/public/interfaces/RegisterInterface.iol"

execution{concurrent}

//----------------OUTPUT PORT-------------------------

outputPort Truck {
Protocol: sodep
Interfaces: TruckInterface
}

outputPort Rental{
Protocol: sodep
Interfaces: RentalInterface
}

outputPort Car {
Protocol: sodep
Interfaces: CarPrivateInterface
}

outputPort Register {
Protocol: sodep
Location: Location_Register
Interfaces: RegisterInterface
}

outputPort Orchestrator {
Protocol: sodep
Location: "local"
Interfaces: InnerOrchestratorInterface
}

//-----------------INPUT PORT--------------------------
inputPort Orchestrator {
Location: "local"
Interfaces: OrchestratorInterface, InnerOrchestratorInterface
}

//------------------CODE----------------------------------

define garage {
	setMessage@Car( "Booking a garage..." );
	scope( garageScope ){
		
		install( GarageNotFound => 
			setMessage@Car( "!- GarageNotFound" );
			throw( faultGarage )
		);
		
		install( BankFault =>
					setMessage@Car( "!- Bank Fault in Garage. Credit limit reached!" );
					setMessage@Car( "!- Aborted garage booking" );
					throw( faultGarage )
		);
		
		// selecting garages from register
		sel_garage_req.car_coord = global.car_coord;
		sel_garage_req.car_location = global.car_location;
		selectGarage@Orchestrator( sel_garage_req )( garage_selection_response );

		install( this => 
			rev_garage.reservationId = ^garage_selection_response.reservationId;
			rev_garage.garage_name = ^garage_selection_response.name;
			Garage.location = garage_selection_response.location; 
			garageRevbook@Garage( rev_garage );
			setMessage@Car( "!- Revoked garage booking" )
		);
		Garage.location = garage_selection_response.location; 
		garage_name = garage_selection_response.name;
		global.garage_coord = garage_selection_response.garage_coord;
		g_id = garage_selection_response.reservationId;
		
		setMessage@Car( "!- garage booked:" 
			+ garage_name
			+ ", \n\ttransactionId:" + garage_selection_response.transactionId
			+ ", \n\treservationId:" + garage_selection_response.reservationId );
		
		garage_payment_request.transactionId = garage_selection_response.transactionId;
		garage_payment_request.amount = garage_selection_response.amount;
		garage_payment_request.bankLocation = garage_selection_response.bankLocation;
		pay@Car( garage_payment_request ) (  );
		install( this =>	
			setMessage@Car( "!- Revoking garage booking..." );
			revreq.reservationId = g_id;
			revreq.garage_name = garage_name;
			garageRevbook@Garage( revreq );
			setMessage@Car( "!- Revoked garage booking. Aborting bank transaction..." );
			abort_garage_request << garage_payment_request;
			abortTransaction@Car( abort_garage_request )();
			setMessage@Car( "!- Aborted bank transaction for garage" )
		);
		setMessage@Car( "!- Garage payment: done" )
	}
}


init {
  install( GarageNotFound => nullProcess )
}

main
{
	
	
	[ start( begin )]{
		// initializing the orchestrator
		global.car_location = begin.location;
		Car.location = global.car_location;
		getGPSCoordinates@Car()( car );
		global.car_coord -> car.coord;
		getLocalLocation@Runtime()( orchestrator_location );
		Orchestrator.location = orchestrator_location;
		getCarData@Car()( car_data_response );
		global.car_data << car_data_response;

		install( faultGarage => 
			nullProcess 
		);

		// main workflow
		garage
	}

	[ selectGarage( request )( response ){

		Car.location = request.car_location;
		
		// retrieving garage list from registry
		req_reg_garage.service = "garage";
		req_reg_garage.coord = request.car_coord;
		lookFor@Register( req_reg_garage )( resp_reg_garage );

		// retrieving garage prices from garage services
		for ( g=0, g < #resp_reg_garage.row, g++ ) {
			Garage.location = resp_reg_garage.row[ g ].location;
			price_garage_request.serviceType = "garage_recovering";
			price_garage_request.garage_name = resp_reg_garage.row[ g ].name;
			scope( get_garage_price ) {
			  install( IOException => setMessage@Car("garage service is not responding");
						  resp_reg_garage.row[ g ].price = 0
			  );
			  getGaragePrice@Garage( price_garage_request )( garage_price );
			  resp_reg_garage.row[ g ].price = garage_price.price
			}
		};
		

		resp_reg_garage.msg="Garages available:";
		selected_garage = false;
		garage_count = #resp_reg_garage.row;
		while ( ( garage_count > 0 ) && ( selected_garage == false ) ) {
			scope( garage ) {
				
				install( GarageBookFault =>
					setMessage@Car("! - booking attempt failed for garage " + resp_reg_garage.row[resp_garage_selection.selection].name );
					undef( resp_reg_garage.row[resp_garage_selection.selection] );
					resp_reg_garage.msg="The selected garage is not available. Select another garage:";
					garage_count = #resp_reg_garage.row
				);

				
				// selecting the garage by using the functionalities offered by the car
				selectService@Car( resp_reg_garage )( resp_garage_selection );
				Garage.location = resp_garage_selection.location;

				scope( io_garage ) {
				  install( IOException => setMessage@Car("service of garage " + resp_garage_selection.name + " is not availble now, discarded.");
							  throw( GarageBookFault )
				  );
				  // booking the selected garage
				  with( garage_book_request ) {
				    .garage_name = resp_garage_selection.name;
				    .name = global.car_data.name;
				    .serviceType = "garage_recovering";
				    .surname = global.car_data.surname;
				    .car_model = global.car_data.car_model;
				    .plate = global.car_data.plate;
				    .bankLocation = global.car_data.bank_location
				  };
				  garageBook@Garage( garage_book_request )( garage_book_response )
				};
				selected_garage = true;
				setMessage@Car( "Garage selection done" );

				// preparing response
				with( response ) {
				  .garage_coord = resp_garage_selection.coord;
				  .location = Garage.location;
				  .name = resp_garage_selection.name;
				  .amount = garage_book_response.amount;
				  .reservationId = garage_book_response.reservationId;
				  .transactionId = garage_book_response.transactionId;
				  .bankLocation = garage_book_response.bankLocation
				}
			}
		};
		if ( selected_garage == false ) { 	
			setMessage@Car( "! - No more garages available" );
			throw( GarageNotFound ) 
		}
	}]{ nullProcess }
}