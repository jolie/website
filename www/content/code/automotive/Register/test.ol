include "console.iol"
include "../locations.iol"


interface RegisterInterface {
RequestResponse:
	lookFor
}

outputPort Register {
Protocol: sodep
Location: Location_Register
Interfaces: RegisterInterface
}


main
{
	request.service = "rental";
	lookFor@Register( request )( response );
	for ( i =0, i<#response.row, i++) {
		foreach ( x:response.row[i] ) {
			println@Console( x + ":" + response.row[i].(x) )()
		}
	}
}