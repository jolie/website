// Printer.iol
interface PrinterInterface {
	OneWay: printText( string )
}

//dynamic_binding_example.ol

include "console.iol"
include "Printer.iol"

outputPort P {
	Location: "socket://p:80"
	Protocol: sodep
	Interface: PrinterInterface
}

main
{
	println@Console( P.location )();
	println@Console( P.protocol )()
}