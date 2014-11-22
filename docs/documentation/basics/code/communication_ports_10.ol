//Client.ol

include "console.iol"
include "percentInterface.iol"

outputPort PercService {
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: PercentInterface
}

define valid_request {
	request.total = 10;
	request.part = 3
}

define typeMismatch_request {
	request.total = 10.0;
	request.part = 3
}

main
{
	install( TypeMismatch =>
				println@Console( "TypeMismatch: " + main.TypeMismatch )()
		);
	//valid_request;
	error_request_1;
	percent@PercService( request )( response );
	println@Console( "\n"+"Percentage value: "+response.percent_value )()
}