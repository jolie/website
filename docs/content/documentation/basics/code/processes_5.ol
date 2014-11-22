include "regInterface.iol"
include "console.iol"

outputPort Register {
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: RegService
}

main 
{
	register@Register()( response );
	println@Console( response.message )()
}