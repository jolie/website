outputPort Registry {
	// omitted
}

outputPort Printer {
	Interfaces: PrinterInterface
}

main
{
	getBinding@Registry( "LaserPrinter" )( Printer );
	printText@Printer( "My text" )
}