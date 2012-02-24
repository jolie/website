init
{
	console_req.enableSessionListener = true;
	registerForInput@Console( console_req )();
	install( TruckBookFault => nullProcess )
}

main
{
	
	
	[ truckBook( request )( response ){ 
		csets.coreJavaserviceConsoleToken = new;
		console_listener.token = csets.coreJavaserviceConsoleToken;
		subscribeSessionListener@Console( console_listener )();

		csets.reservationId = new;

		println@Console("! - Received booking request:")();
		println@Console("\t\tService type: " + request.serviceType )();
		println@Console("\t\tCar model: " + request.car_model)();
		print@Console("Do you accept[yes/no]? ")();
		in( accept );
		unsubscribeSessionListener@Console( console_listener )();

		if ( accept == "yes" ) {
			with( bank_request ) {
			  .amount = services.( request.serviceType ).price;
			  .account << account;
			  .location = myLocation;
			  .correlation_data.reservationId = csets.reservationId
			};
			openTransaction@Bank( bank_request )( bank_response );
			csets.transactionId = bank_response.transactionId;

			// preparing response
			with( response ) {
			  .reservationId = csets.reservationId;
			  .amount = services.( request.serviceType ).price;
			  .transactionId = csets.transactionId;
			  .bankLocation = Bank.location
			};
			println@Console("! - Booked request for reservationId:" + 
					csets.reservationId + " bank transaction id:" + bank_response.transactionId )()
		} else {
			throw ( TruckBookFault )
		}
		
		
	} ]{ bankCommit( request );
	      if ( request.result == false ) {
		println@Console("! - transaction aborted. Reservation " + csets.reservationId + " cancelled!")()
	      } else {
		println@Console("! - transaction succeeded. Reservation " + csets.reservationId + " confirmed!")()
	      }
	}
	
	[ truckRevbook( request )]{
		println@Console("! - Reversed booking for reservationId: " + request.reservationId )()
	}
	
	[ getTruckPrice( request )( response ){
		response.price= services.( request.serviceType ).price
	}]{ nullProcess }
}