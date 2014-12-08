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
	install( fault_number=>
		println@Console( main.fault_number.fault_error )()
	);
	guess@Guess( 12 )( response );
	println@Console( response )()
}