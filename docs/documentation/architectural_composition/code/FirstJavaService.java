package org.jolie.example;

import jolie.runtime.JavaService;
import jolie.runtime.Value;

public class FirstJavaService extends JavaService
{
	public Value HelloWorld( Value request ) {
		String message = request.getFirstChild( "message" ).strValue();
		System.out.println( message );
		Value response = Value.create();
		response.getFirstChild( "reply" ).setValue( "I am your father" );
		return response;
	}
}
