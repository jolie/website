init
{
	registerForInput@Console()()
}

main
{
	install( BookFault => nullProcess );
	
	[ book( request )( response ){ 
		println@Console("! - Received booking request:")();
		println@Console("\t\tService type: " + request.serviceType)();
		println@Console("\t\tCar model: " + request.car_model)();
		print@Console("Do you accept[yes/no]? ")();
		in( accept );
		if ( accept == "yes" ) {
			bank_request.amount = services.( request.serviceType ).price;
			bank_request.account << account;
			bank_request.location = myLocation;
			synchronized( lock ) {
				global.counter = global.counter + 1;
				reservationId = global.counter
			};
			bank_request.location.cset.reservationId = reservationId;
			openTransaction@Bank( bank_request )( bank_response );
			response.reservationId = reservationId;
			response.amount = services.( request.serviceType ).price;
			transactionId = bank_response.transactionId;
			response.transactionId = transactionId;
			response.bankLocation = Bank.location;
			println@Console("! - Booked request for reservationId:" + 
					global.counter + " bank transaction id:" + bank_response.transactionId )()
		} else {
			throw ( BookFault )
		}
		
		
	} ]{ bankCommit( request ) }
	
	[ revbook( request )]{
		println@Console("! - Reversed booking for reservationId: " + request )()
	}
	
	[getPrice( request )( response ){
		response.price= services.( request.serviceType ).price
	}]{ nullProcess }
}