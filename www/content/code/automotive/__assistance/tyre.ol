include "../locations.iol"
include "runtime.iol"
include "console.iol"

execution{concurrent}

interface CarInnerInterface {
RequestResponse:
	getGPSCoordinates,
	getUserData,
	pay throws BankFault,
	abortTransaction,
	select1, select2,
	getAccount
OneWay:
	setMessage
}

interface OrchestratorInterface {
OneWay:
	start
}

interface RegisterInterface {
RequestResponse:
/* return a selection list
@request:void {
*	.service:string 	// service type
*	.coord:string 		// coar coordinates
*}
@response: any { 
*	row[0..*]:any 
*}
*/
	lookFor
}


interface GarageInterface {
RequestResponse:
	book throws BookFault,
	getPrice 
OneWay:
	revbook
}


//----------------OUTPUT PORT-------------------------
outputPort Garage {
Protocol: sodep
Interfaces: GarageInterface
}

outputPort Car {
Protocol: sodep
Interfaces: CarInnerInterface
}

outputPort Register {
Protocol: sodep
Location: Location_Register
Interfaces: RegisterInterface
}

//-----------------INPUT PORT--------------------------
inputPort Orchestrator {
Location: "local"
Interfaces: OrchestratorInterface
}

//------------------CODE----------------------------------
define select_garage {
	req_reg_garage.service = "garage";
	req_reg_garage.coord -> car_coord;
	lookFor@Register( req_reg_garage )( resp_reg_garage );
	for ( i=0, i<#resp_reg_garage.row, i++ ) {
		Garage.location = resp_reg_garage.row[i].location;
		price_garage_request.serviceType = "on_the_fly_recoverig";
		getPrice@Garage( price_garage_request )( garage_price );
		resp_reg_garage.row[i].price = garage_price.price
	};
	
	resp_reg_garage.msg="Garages available:";
	
	selected_garage = 0;
	garage_count = #resp_reg_garage.row;
	while ( ( garage_count > 0 ) && ( selected_garage == 0) ) {
		scope( garage ) {
			
			install( BookFault =>
				undef( resp_reg_garage.row[resp_garage_selection.selection] );
				resp_reg_garage.msg="The selected garage is not available. Select another garage:";
				setMessage@Car( "! - booking garage attempt failed." );
				garage_count = #resp_reg_garage.row
			);
			
			select1@Car( resp_reg_garage )( resp_garage_selection );
			Garage.location = resp_garage_selection.row[0].location;
			garage_coord = resp_garage_selection.row[0].coord;	
			garage_book_request -> user;
			garage_book_request.serviceType = "on_the_fly_recoverig";
			book@Garage( garage_book_request )( response );
			garage_selection_response << response;
			garage_selection_response.garage_coord = garage_coord;
			garage_selection_response.location = Garage.location;
			garage_selection_response.name = resp_garage_selection.row[0].name;
			selected_garage = 1
			
		}
	};
	if ( selected_garage == 0 ) { 	
		setMessage@Car("! - No more garages available" );
		throw( GarageNotFound ) 
	}
}

main
{	
	start( begin );
	global.car_location = begin.location;
	Car.location = global.car_location;
	getGPSCoordinates@Car()( car );
	car_coord -> car.coord;
	println@Console("carmodel"+global.car_model)();
	getUserData@Car()( user );
	
	setMessage@Car(". - Booking a garage...");
		
	install( GarageNotFound => 
		setMessage@Car( "!- GarageNotFound" )
	);
	
	install( BankFault =>
				setMessage@Car("! - Bank Fault in Garage");
				revbook@Garage( g_id );
				setMessage@Car("! - Revoked garage booking");
				throw( faultGarage )
	);
		
	select_garage;
	
	install( this => 
		g_id = ^garage_selection_response.reservationId;
		Garage.location = garage_selection_response.location; 
		revbook@Garage( g_id );
		setMessage@Car("! - Revoked garage booking")
	);
	Garage.location = garage_selection_response.location; 
	garage_name = garage_selection_response.name;
	garage_coord = garage_selection_response.garage_coord;
	g_id = garage_selection_response.reservationId;
	
	setMessage@Car(". - garage booked:" 
		+ garage_name
		+ ", transactionId:" + garage_selection_response.transactionId
		+ ", reservationId:" + garage_selection_response.reservationId );

		
	garage_payment_request.transactionId = garage_selection_response.transactionId;
	garage_payment_request.amount = garage_selection_response.amount;
	garage_payment_request.bankLocation = garage_selection_response.bankLocation;
	pay@Car( garage_payment_request ) (  );
	install( this =>	
		revreq.reservationId = g_id;
		revbook@Garage( revreq );
		setMessage@Car("! - Revoked garage booking");
		abort_garage_request << garage_payment_request;
		abort_garage_request.reservationId = garage_selection_response.reservationId;
		abortTransaction@Car( abort_garage_request )();
		setMessage@Car("! - Aborted bank transaction for garage")
	);
	setMessage@Car(". - Garage payment: done")
}