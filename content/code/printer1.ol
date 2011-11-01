include "locations.iol"
include "printer.iol"
include "console.iol"

execution { concurrent }

inputPort PrinterInput {
Location: locationPrinter
Protocol: sodep
Interfaces: PrinterInterface
}

main
{
	[ print( request )( response ) ] {
		println@Console( "Printing job id: " + request.job + ". Content: " + request.content )()
	}
	[ del( request ) ] {
		println@Console( "Deleting job id: " + request.job )()
	}
}