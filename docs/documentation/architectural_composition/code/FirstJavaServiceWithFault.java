public Value HelloWorld( Value request ) throws FaultException {
		String message = request.getFirstChild( "message" ).strValue();
		System.out.println( message );
		if ( !message.equals( "I am Luke" ) ) {
			Value faultMessage = Value.create();
			faultMessage.getFirstChild( "msg" ).setValue( "I am not your father" );
			throw new FaultException( "WrongMessage", faultMessage );
		}
		Value response = Value.create().getFirstChild( message );
		response.getFirstChild( "reply" ).setValue( "I am your father" );
		return response;

	}
