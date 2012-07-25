include "printer.iol"
include "console.iol"

execution { concurrent }

inputPort MyInput {
Location: "socket://localhost:9001"
Protocol: sodep
Interfaces: PrinterInterface
}

main
{
	print( msg );
	println@Console( "[Laser Printer]: " + msg )()
}

