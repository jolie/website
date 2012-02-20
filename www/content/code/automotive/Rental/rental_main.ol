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
		println@Console("\t\tCar model: " + requet.car_model)();
		print@Console("Do you accept[yes/no]? ")();
		in( accept );
		if ( accept == "yes" ) {
			bank_request.amount = services.( request.serviceType ).price;
			bank_request.account << account;
			bank_request.location = myLocation;
			openTransaction@Bank( bank_request )( bank_response );
			synchronized( lock ) {
				global.counter = global.counter + 1;
				response.reservationId = global.counter;
				println@Console("! - Booked request for reservationId:" + 
					global.counter + " bank transaction id:" + bank_response.transactionId )()
			};
			response.amount = services.( request.serviceType ).price;
			response.transactionId = bank_response.transactionId;
			response.bankLocation = Bank.location
		} else {
			throw ( BookFault )
		}
		
		
	} ]{  bankCommit( request );println@Console("! - Received commit")() }
	
	[ revbook( request )]{
		println@Console("! - Reversed booking for reservationId: " + request )()
	}
	
	[getPrice( request )( response ){
		response.price= services.( request.serviceType ).price;
		println@Console("Served getPrice")()
	}]{ nullProcess }
	
	[redirect( request )]{
		println@Console("Redirection request served for reservationId " + request )()
	}
}