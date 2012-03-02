include "runtime.iol"
include "console.iol"
include "string_utils.iol"

include "../config/config.iol"
include "./public/interfaces/OrchestratorInterface.iol"
include "./public/surfaces/CarSurface.iol"
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
Interfaces: CarInnerSurface
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
		linkOut( garageCoordinates );
		
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

define truck {
	setMessage@Car( "Booking a truck..." );
	scope( truckScope ){
		
		install( TruckNotFound => 
			setMessage@Car( "!- TruckNotFound" );
			throw( faultTruck )
		);
		
		install( BankFault =>
					setMessage@Car( "!- Bank Fault in truck payment. Credit limit reached!" );
					setMessage@Car( "!- Aborted truck booking" );
					throw( faultTruck )
		);
		
		sel_truck_req.car_coord = global.car_coord;
		sel_truck_req.car_location = global.car_location;
		selectTruck@Orchestrator( sel_truck_req )( truck_selection_response );
		install( this => 
			truck_rev.reservationId = ^truck_selection_response.reservationId;
			Truck.location = ^truck_selection_response.location; 
			truckRevbook@Truck( truck_rev );
			setMessage@Car( "!- Revoked truck booking" )
		);
		Truck.location = truck_selection_response.location; 
		truck_name = truck_selection_response.name;
		t_id = truck_selection_response.reservationId;
		
		setMessage@Car( "! - truck booked:" 
			+ truck_name 
			+ ",\n transactionId:" + truck_selection_response.transactionId
			+ ",\n reservationId:" + truck_selection_response.reservationId );
		
		truck_payment_request.transactionId = truck_selection_response.transactionId;
		truck_payment_request.amount = truck_selection_response.amount;
		truck_payment_request.bankLocation = truck_selection_response.bankLocation;
		pay@Car( truck_payment_request ) (  );
		install( this =>	
			truck_rev.reservationId = t_id;
			truckRevbook@Truck( truck_rev );
			setMessage@Car( "!- Revoked truck booking" );
			abort_truck_request << truck_payment_request;
			abort_truck_request.reservationId = truck_selection_response.reservationId;
			abortTransaction@Car( abort_truck_request )();
			setMessage@Car( "!- Aborted bank transaction for truck" )
		);
		setMessage@Car( "! - Truck payment: done" )
	}
}

define rental_booking_message {
	Rental.location = rental_selection_response.location; 
	rental_name = rental_selection_response.name;
	r_id = rental_selection_response.reservationId;
	setMessage@Car( "! - Car rental service booked:" 
		+ rental_name 
		+ ",\n transactionId:" + rental_selection_response.transactionId
		+ ",\n reservationId:" + rental_selection_response.reservationId )
}

define rental_payment {
	rental_payment_request.transactionId = rental_selection_response.transactionId;
	rental_payment_request.amount = rental_selection_response.amount;
	rental_payment_request.bankLocation = rental_selection_response.bankLocation;
	pay@Car( rental_payment_request ) (  )
}


define rental {
	
	scope( rentalScope ) {
		
		install( RentalNotFound => 
			setMessage@Car( "!- RentalNotFound" );
			setMessage@Car( "! - No more available cars for renting!" )
		);
		
		install( BankFault =>
					setMessage@Car( "!- Bank Fault in Renting a car. Credit limit reached!" );
					setMessage@Car( "!- Aborted car rent booking" )
		); 

		install( this =>
			setMessage@Car( "Renting a car without garage...\n" );
			install( BankFault =>
						setMessage@Car( "!- Bank Fault in Renting a car. Credit limit reached!" );
						setMessage@Car( "!- Aborted car rent booking" )
			);
			
			select_rental_request.coord = global.car_coord;
			select_rental_request.car_location = global.car_location;
			selectRental@Orchestrator( select_rental_request )();
			
			rental_booking_message;
				
			rental_payment;
			setMessage@Car( "! -Car rental payment: done" )
		);

		// waiting for receiving garage coordinates
		linkIn( garageCoordinates );
		setMessage@Car( "Renting a car with garage...\n" );

		select_rental_request.car_location = global.car_location;
		select_rental_request.coord = global.garage_coord;
		selectRental@Orchestrator( select_rental_request )( rental_selection_response )[
			this => 
				install( BankFault =>
						setMessage@Car( "!- Bank Fault in Renting a car. Credit limit reached!" );
						setMessage@Car( "!- Aborted car rent booking" )
				);
				
				r_id = rental_selection_response.reservationId;
				Rental.location = rental_selection_response.location; 
				redirect@Rental( r_id );
				setMessage@Car( "!- Redirected car rental service" );
				
				rental_booking_message;
		
				rental_payment
	
		];
		
		rental_booking_message;
		
		rental_payment;
		
		install( this =>	
			redirect@Rental( r_id );
			setMessage@Car( "!- Redirected car rental service" )
		);
		setMessage@Car( "! -Car rental payment: done" )
		
	}
}

init {
  install( GarageNotFound => nullProcess );
  install( TruckNotFound => nullProcess );
  install( RentalNotFound => nullProcess )
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
			comp( rentalScope ) 
		);
		install( faultTruck =>
			{comp( garageScope )} 
			| 
			{comp( rentalScope )}
		);

		// main workflow
		{
			{ rental }
			|
			{ garage; truck }
		}
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
	
	[ selectTruck( request )( response ){
		Car.location = request.car_location;

		// retrivieng truck service list from registry
		req_reg_truck.service = "truck";
		req_reg_truck.coord = request.car_coord;
		lookFor@Register( req_reg_truck )( resp_reg_truck );

		for ( t = 0, t < #resp_reg_truck.row, t++ ) {
			Truck.location = resp_reg_truck.row[ t ].location;
			price_truck_request.serviceType = "truck_recovering";
			scope( get_truck_price ) {
			  install( IOException => resp_reg_truck.row[ t ].price = 0 );

			  getTruckPrice@Truck( price_truck_request )( truck_price );
			  resp_reg_truck.row[ t ].price = truck_price.price
			}
		};
		
		resp_reg_truck.msg="Truck Services available:";
		selected_truck = false;
		truck_count = #resp_reg_truck.row; 
		while ( ( truck_count > 0) && ( selected_truck == false ) ) {
			scope( truck ) {
				
				install( TruckBookFault =>
					undef( resp_reg_truck.row[resp_truck_selection.selection] );
					resp_reg_truck.msg="The selected service is not available. Please, select another service:";
					setMessage@Car( "! - booking truck attempt failed." );
					truck_count = #resp_reg_truck.row
				);
			        selectService@Car( resp_reg_truck )( resp_truck_selection );
				Truck.location = resp_truck_selection.location;
				
				scope( io_truck ) {
				  install( IOException => setMessage@Car("service of truck " + resp_truck_selection.name + " is not availble now, discarded.");
							  throw( TruckBookFault )
				  );
				  // booking the selected garage
				  with( truck_book_request ) {
				    .name = global.car_data.name;
				    .serviceType = "truck_recovering";
				    .surname = global.car_data.surname;
				    .car_model = global.car_data.car_model;
				    .plate = global.car_data.plate;
				    .bankLocation = global.car_data.bank_location
				  };
				  truckBook@Truck( truck_book_request )( truck_book_response )
				};
				
				selected_truck = true;
				setMessage@Car( "Truck selection done!" );
			      
				// preparing response
				with( response ) {
				  .location = Truck.location;
				  .name = resp_truck_selection.name;
				  .amount = truck_book_response.amount;
				  .reservationId = truck_book_response.reservationId;
				  .transactionId = truck_book_response.transactionId;
				  .bankLocation = truck_book_response.bankLocation
				}
				
			}
		};
		if ( selected_truck == false ) { 	
			setMessage@Car( "! - No more truck available" );
			throw( TruckNotFound ) 
		}
	}]{ nullProcess }
	
	[ selectRental( request )( response ) {
		Car.location = request.car_location;
		
		// retrieving rental service list from registry
		Car.location = request.car_location;
		req_reg_rental.service = "rental";
		req_reg_rental.coord = request.coord;
		lookFor@Register( req_reg_rental )( resp_reg_rental );

		for ( r =0, r < #resp_reg_rental.row, r++ ) {
			Rental.location = resp_reg_rental.row[ r ].location;
			price_rental_request.serviceType = "rental_recovering";
			scope( get_rental_price ) {
			  install( IOException => resp_reg_rental.row[ r ].price = 0 );
			  
			  getRentalPrice@Rental( price_rental_request )( rental_price );
			  resp_reg_rental.row[ r ].price = rental_price.price
			}
		};
		
		resp_reg_rental.msg="Car Rental Services available:";
		selected_rental = false;
		rental_count = #resp_reg_rental.row; 
		while ( ( rental_count > 0) && ( selected_rental == false ) ) {
			scope( rental ) {
				
				install( RentalBookFault =>
					undef( resp_reg_rental.row[resp_rental_selection.selection] );
					resp_reg_rental.msg="The selected service is not available. Please, select another service:";
					setMessage@Car( "! - booking car rental service attempt failed." );
					rental_count = #resp_reg_rental.row
				);

				// selecting a rental by using functionalities of the car
			        selectService@Car( resp_reg_rental )( resp_rental_selection );
				Rental.location = resp_rental_selection.location;

				scope( io_rental ) {
				  install( IOException => setMessage@Car("service of rental " + resp_rental_selection.name + " is not availble now, discarded.");
							  throw( RentalBookFault )
				  );
				  // booking rental service
				  with( rental_book_request ) {
				    .name = global.car_data.name;
				    .serviceType = "rental_recovering";
				    .surname = global.car_data.surname;
				    .car_model = global.car_data.car_model;
				    .plate = global.car_data.plate;
				    .bankLocation = global.car_data.bank_location;
				    .coord = request.coord
				  };				
				  rentalBook@Rental( rental_book_request )( rental_book_response )
				};
				selected_rental = true;
				setMessage@Car( "Car rental service selection done!" );

				// preparing response
				with( response ) {
				  .location = Rental.location;
				  .name = resp_rental_selection.name;
				  .amount = rental_book_response.amount;
				  .reservationId = rental_book_response.reservationId;
				  .transactionId = rental_book_response.transactionId;
				  .bankLocation = rental_book_response.bankLocation
				}
				
			}
		};
		if ( selected_rental == false ) { 	
			setMessage@Car( "! - No more car available" );
			throw( RentalNotFound ) 
		}
		
	}] { nullProcess }
}