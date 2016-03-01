//client.ol
include "console.iol"
include "interface.iol"

outputPort Guess {
	Protocol: sodep
	Location: "socket://localhost:2000"
	Interfaces: Guess
}

main
{
	install( NumberException=>
		println@Console( main.NumberException.exceptionMessage )()
	);
	guess@Guess( 12 )( response );
	println@Console( response )()
}