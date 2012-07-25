include "printer.iol"
include "console.iol"

execution { concurrent }

inputPort MyInput {
Location: "socket://localhost:9002"
Protocol: sodep
Interfaces: PrinterInterface
}

main
{
	print( msg );
	println@Console( "[InkJet Printer]: " + msg )()
}

