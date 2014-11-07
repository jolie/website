include "Printer.iol"

outputPort P {
	Interfaces: PrinterInterface
}

main
{
	P.location = "socket://p:80/";
	P.protocol = "sodep"
}