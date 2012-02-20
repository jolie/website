include "../config/config.iol"
include "runtime.iol"
include "console.iol"
include "./public/interfaces/OrchestratorInterface.iol"
include "./public/interfaces/CarPrivateInterface.iol"

execution{concurrent}

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

interface RentalInterface {
RequestResponse:
	book throws BookFault,
	getPrice
OneWay:
	revbook, redirect
	
}

interface GarageInterface {
RequestResponse:
	book throws BookFault,
	getPrice 
OneWay:
	revbook
}

interface TruckInterface {
RequestResponse:
	book throws BookFault,
	getPrice 
OneWay:
	revbook
}

interface InnerOrchestratorInterface {
RequestResponse:
	selectGarage throws GarageNotFound,
	selectTruck throws TruckNotFound,
	selectRental throws RentalNotFound
}


//----------------OUTPUT PORT-------------------------
outputPort Garage {
Protocol: sodep
Interfaces: GarageInterface
}

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
	msg_car.msg = "Booking a garage...";
	setMessage@Car( msg_car );
	scope( garageScope ){
		
		install( GarageNotFound => 
			msg_car.msg = "!- GarageNotFound";
			setMessage@Car( msg_car );
			throw( faultGarage )
		);
		
		install( BankFault =>
					msg_car.msg = "!- Bank Fault in Garage";
					setMessage@Car( msg_car );
					revbook@Garage( g_id );
					msg_car.msg = "!- Revoked garage booking";
					setMessage@Car( msg_car );
					throw( faultGarage )
		);
		
		selectGarage@Orchestrator()( garage_selection_response );
		install( this => 
			g_id = ^garage_selection_response.reservationId;
			Garage.location = garage_selection_response.location; 
			revbook@Garage( g_id );
			msg_car.msg = "!- Revoked garage booking";
			setMessage@Car( msg_car )
		);
		Garage.location = garage_selection_response.location; 
		garage_name = garage_selection_response.name;
		garage_coord = garage_selection_response.garage_coord;
		g_id = garage_selection_response.reservationId;
		
		msg_car.msg = "!- garage booked:" 
			+ garage_name
			+ ", transactionId:" + garage_selection_response.transactionId
			+ ", reservationId:" + garage_selection_response.reservationId;
		setMessage@Car( msg_car );
		linkOut( garageCoordinates );
		
		garage_payment_request.transactionId = garage_selection_response.transactionId;
		garage_payment_request.amount = garage_selection_response.amount;
		garage_payment_request.bankLocation = garage_selection_response.bankLocation;
		pay@Car( garage_payment_request ) (  );
		install( this =>	
			revreq.reservationId = g_id;
			revbook@Garage( revreq );
			msg_car.msg = "!- Revoked garage booking";
			setMessage@Car( msg_car );
			abort_garage_request << garage_payment_request;
			abort_garage_request.reservationId = garage_selection_response.reservationId;
			abortTransaction@Car( abort_garage_request )();
			msg_car.msg = "!- Aborted bank transaction for garage";
			setMessage@Car( msg_car )
		);
		msg_car.msg = "!- Garage payment: done";
		setMessage@Car( msg_car )
	}
}

define truck {
	msg_car.msg = "Booking a truck...";
	setMessage@Car( msg_car );
	scope( truckScope ){
		
		install( TruckNotFound => 
			msg_car.msg = "!- TruckNotFound";
			setMessage@Car( msg_car );
			throw( faultTruck );
			msg_car.msg = "sblock";
			setMessage@Car( msg_car )
		);
		
		install( BankFault =>
					msg_car.msg = "!- Bank Fault in truck payment";
					setMessage@Car( msg_car );
					revbook@Truck( t_id );
					msg_car.msg = "!- Revoked truck booking";
					setMessage@Car( msg_car );
					throw( faultTruck )
		);
		
		selectTruck@Orchestrator()( truck_selection_response );
		install( this => 
			t_id = ^truck_selection_response.reservationId;
			Truck.location = ^truck_selection_response.location; 
			revbook@Truck( g_id );
			msg_car.msg = "!- Revoked truck booking";
			setMessage@Car( msg_car )
		);
		Truck.location = truck_selection_response.location; 
		truck_name = truck_selection_response.name;
		t_id = truck_selection_response.reservationId;
		
		msg_car.msg = "! - truck booked:" 
			+ truck_name 
			+ ", transactionId:" + truck_selection_response.transactionId
			+ ", reservationId:" + truck_selection_response.reservationId;
		setMessage@Car( msg_car );
		
		truck_payment_request.transactionId = truck_selection_response.transactionId;
		truck_payment_request.amount = truck_selection_response.amount;
		truck_payment_request.bankLocation = truck_selection_response.bankLocation;
		pay@Car( truck_payment_request ) (  );
		install( this =>	
			revbook@Truck( t_id );
			msg_car.msg = "!- Revoked truck booking";
			setMessage@Car( msg_car );
			abort_truck_request << truck_payment_request;
			abort_truck_request.reservationId = truck_selection_response.reservationId;
			abortTransaction@Car( abort_truck_request )();
			msg_car.msg = "!- Aborted bank transaction for truck";
			setMessage@Car( msg_car )
		);
		msg_car.msg = "! - Truck payment: done";
		setMessage@Car( msg_car )
	}
}

define rental_booking_message {
	Rental.location = rental_selection_response.location; 
	rental_name = rental_selection_response.name;
	r_id = rental_selection_response.reservationId;
	msg_car.msg = "! - Car rental service booked:" 
		+ rental_name 
		+ ", transactionId:" + rental_selection_response.transactionId
		+ ", reservationId:" + rental_selection_response.reservationId;
	setMessage@Car( msg_car )
}

define rental_payment {
	rental_payment_request.transactionId = rental_selection_response.transactionId;
	rental_payment_request.amount = rental_selection_response.amount;
	rental_payment_request.bankLocation = rental_selection_response.bankLocation;
	pay@Car( rental_payment_request ) (  )
}


define rental {
	msg_car.msg = "Renting a car...\n";
	setMessage@Car( msg_car );
	scope( rentalScope ) {
		
		install( RentalNotFound => 
			msg_car.msg = "!- RentalNotFound";
			setMessage@Car( msg_car );
			msg_car.msg = "! - No more available cars for renting!";
			setMessage@Car( msg_car )
		);
		
		install( BankFault =>
					msg_car.msg = "!- Bank Fault in Rent a car";
					setMessage@Car( msg_car );
					revbook@Rental( r_id );
					msg_car.msg = "!- Revoked rent booking";
					setMessage@Car( msg_car )
		);
		
		linkIn( garageCoordinates );
		select_rental_request.coord = garage_coord;
		install( this =>
		
			install( BankFault =>
						msg_car.msg = "!- Bank Fault in Rent a car";
						setMessage@Car( msg_car );
						revbook@Rental( r_id );
						msg_car.msg = "!- Revoked rent booking";
						setMessage@Car( msg_car )
			);
			
			select_rental_request.coord = car_coord;
			selectRental@Orchestrator( select_rental_request )();
			
			rental_booking_message;
				
			rental_payment;
			msg_car.msg = "! -Car rental payment: done";
			setMessage@Car( msg_car )
		);
			
		selectRental@Orchestrator( select_rental_request )( rental_selection_response )[
			this => 
				install( BankFault =>
						msg_car.msg = "!- Bank Fault in Rent a car";
						setMessage@Car( msg_car );
						revbook@Rental( r_id );
						msg_car.msg = "!- Revoked rent booking";
						setMessage@Car( msg_car )
				);
				
				r_id = rental_selection_response.reservationId;
				Rental.location = rental_selection_response.location; 
				redirect@Rental( r_id );
				msg_car.msg = "!- Redirected car rental service";
				setMessage@Car( msg_car );
				
				rental_booking_message;
		
				rental_payment
	
		];
		
		rental_booking_message;
		
		rental_payment;
		
		install( this =>	
			redirect@Rental( r_id );
			msg_car.msg = "!- Redirected car rental service";
			setMessage@Car( msg_car )
		);
		msg_car.msg = "! -Car rental payment: done";
		setMessage@Car( msg_car )
		
	}
}

init {
  install( GarageNotFound => nullProcess );
  install( TruckNotFound => nullProcess )
}

main
{
	
	
	[ start( begin )]{
		global.car_location = begin.location;
		Car.location = global.car_location;
		getGPSCoordinates@Car()( car );
		car_coord -> car.coord;
		getLocalLocation@Runtime()( orchestrator_location );
		Orchestrator.location = orchestrator_location;
		getBankAccount@Car()( user );
		install( faultGarage => 
			msg_car.msg = "!- Fault in garage activity, compensating rental activity... ";
			setMessage@Car( msg_car );
			comp( rentalScope ) 
		);
		install( faultTruck =>
			msg_car.msg = "!- Fault received from truck service, compensating.";
			setMessage@Car( msg_car ); 
			{comp( garageScope )} 
			| 
			{comp( rentalScope )}
		);
		{
			{ rental }
			|
			{ garage; truck }
		}
	}

	[ selectGarage()( response ){
		Car.location = global.car_location;
		req_reg_garage.service = "garage";
		req_reg_garage.coord -> car_coord;
		lookFor@Register( req_reg_garage )( resp_reg_garage );
		for ( i=0, i<#resp_reg_garage.row, i++ ) {
			Garage.location = resp_reg_garage.row[i].location;
			price_garage_request.serviceType = "garage_recovering";
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
					msg_car.msg = "! - booking garage attempt failed.";
					setMessage@Car( msg_car );
					garage_count = #resp_reg_garage.row
				);
				
				selectService@Car( resp_reg_garage )( resp_garage_selection );
				Garage.location = resp_garage_selection.row[0].location;
				garage_coord = resp_garage_selection.row[0].coord;	
				garage_book_request -> user;
				garage_book_request.serviceType = "garage_recovering";
				book@Garage( garage_book_request )( response );
				response.garage_coord = garage_coord;
				response.location = Garage.location;
				response.name = resp_garage_selection.row[0].name;
				selected_garage = 1;
				msg_car.msg = "Garage selection done";
				setMessage@Car( msg_car )
				
			}
		};
		if ( selected_garage == 0 ) { 	
			msg_car.msg = "! - No more garages available";
			setMessage@Car( msg_car );
			throw( GarageNotFound ) 
		}
	}]{ nullProcess }
	
	[ selectTruck()( response ){
		Car.location = global.car_location;
		req_reg_truck.service = "truck";
		req_reg_truck.coord -> car_coord;
		lookFor@Register( req_reg_truck )( resp_reg_truck );
		for ( i=0, i<#resp_reg_truck.row, i++ ) {
			Truck.location = resp_reg_truck.row[i].location;
			price_truck_request.serviceType = "truck_recovering";
			getPrice@Truck( price_truck_request )( truck_price );
			resp_reg_truck.row[i].price = truck_price.price
		};
		
		resp_reg_truck.msg="Truck Services available:";
		selected_truck = 0;
		truck_count = #resp_reg_truck.row; 
		while ( ( truck_count > 0) && ( selected_truck == 0) ) {
			scope( truck ) {
				
				install( BookFault =>
					undef( resp_reg_truck.row[resp_truck_selection.selection] );
					resp_reg_truck.msg="The selected service is not available. Please, select another service:";
					msg_car.msg = "! - booking truck attempt failed.";
					setMessage@Car( msg_car );
					truck_count = #resp_reg_truck.row
				);
			        selectService@Car( resp_reg_truck )( resp_truck_selection );
				Truck.location = resp_truck_selection.row[0].location;
				truck_book_request -> user;
				truck_book_request.serviceType = "truck_recovering";
				book@Truck( truck_book_request )( response );
				response.location = Truck.location;
				response.name = resp_truck_selection.row[0].name;
				selected_truck = 1;
				msg_car.msg = "Truck selection done!";
				setMessage@Car( msg_car )
				
			}
		};
		if ( selected_truck == 0 ) { 	
			msg_car.msg = "! - No more truck available";
			setMessage@Car( msg_car );
			throw( TruckNotFound ) 
		}
	}]{ nullProcess }
	
	[ selectRental( request )( response ) {
		Car.location = global.car_location;
		req_reg_rental.service = "rental";
		req_reg_rental.coord -> garage_coord;
		lookFor@Register( req_reg_rental )( resp_reg_rental );
		for ( i=0, i<#resp_reg_rental.row, i++ ) {
			Rental.location = resp_reg_rental.row[i].location;
			price_rental_request.serviceType = "rental_recovering";
			getPrice@Rental( price_rental_request )( rental_price );
			resp_reg_rental.row[i].price = rental_price.price
		};
		
		resp_reg_rental.msg="Car Rental Services available:";
		selected_rental = 0;
		rental_count = #resp_reg_rental.row; 
		while ( ( rental_count > 0) && ( selected_rental == 0) ) {
			scope( rental ) {
				
				install( BookFault =>
					undef( resp_reg_rental.row[resp_rental_selection.selection] );
					resp_reg_rental.msg="The selected service is not available. Please, select another service:";
					msg_car.msg = "! - booking car rental service attempt failed.";
					setMessage@Car( msg_car );
					rental_count = #resp_reg_rental.row
				);
			        selectService@Car( resp_reg_rental )( resp_rental_selection );
				Rental.location = resp_rental_selection.row[0].location;
				rental_book_request -> user;
				rental_book_request.serviceType = "rental_recovering";
				rental_book_request.coord = request.coord;
				book@Rental( rental_book_request )( response );
				response.location = Rental.location;
				response.name = resp_rental_selection.row[0].name;
				selected_rental = 1;
				msg_car.msg = "Car rental service selection done!";
				setMessage@Car( msg_car )
				
			}
		};
		if ( selected_rental == 0 ) { 	
			msg_car.msg = "! - No more car available";
			setMessage@Car( msg_car );
			throw( RentalNotFound ) 
		}
		
	}] { nullProcess }
}