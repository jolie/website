init
{
	console_req.session_listener_enabled = true;
	registerForInput@Console( console_req )();
	install( BookFault => nullProcess )
}

main
{
	
	
	[ garageBook( request )( response ){ 
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
			  .location.correlation_data.reservationId = csets.reservationId
			};
			openTransaction@Bank( bank_request )( bank_response );
			csets.transactionId = bank_response.transactionId;

			// preparing response
			with( response ) {
			  .reservationId = reservationId;
			  .amount = services.( request.serviceType ).price;
			  .transactionId = csets.transactionId;
			  .bankLocation = Bank.location
			};
			println@Console("! - Booked request for reservationId:" + 
					global.counter + " bank transaction id:" + bank_response.transactionId )()
		} else {
			throw ( BookFault )
		}
		
		
	} ]{ bankCommit( request ) }
	
	[ revbook( request )]{
		println@Console("! - Reversed booking for reservationId: " + request )()
	}
	
	[ getGaragePrice( request )( response ){
		response.price= services.( request.serviceType ).price
	}]{ nullProcess }
}