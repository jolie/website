include "locations.iol"
include "printer.iol"
include "console.iol"

execution { concurrent }

inputPort PrinterInput {
Location: Location_Printer2
Protocol: sodep
Interfaces: PrinterInterface
}

main
{
	[ print( request ) ] {
		println@Console( "Printing job id: " + request.job + ". Content: " + request.content )()
	}
	[ del( job ) ] {
		println@Console( "Deleting job id: " + job )()
	}
}