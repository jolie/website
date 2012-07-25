include "printer.iol"
include "registry.iol"

outputPort Printer {
Interfaces: PrinterInterface
}

outputPort Registry {
Location: "socket://localhost:9000/"
Protocol: sodep
Interfaces: RegistryInterface
}

main
{
	if ( args[0] == "laser" ) {
		id = "LaserPrinter"
	} else {
		id = "InkJetPrinter"
	};
	getBinding@Registry( id )( Printer );
	print@Printer( "Hello, World!" )
}

