include "locations.iol"
include "printer.iol"
include "fax.iol"
include "aggregator.iol"

include "console.iol"


execution { concurrent }

outputPort Printer {
Location: Location_Printer
Protocol: sodep
Interfaces: PrinterInterface
}

outputPort Fax {
Location: Location_Fax
Protocol: sodep
Interfaces: FaxInterface
}

inputPort Aggregator {
Location: Location_Aggregator
Protocol: sodep
Interfaces: AggregatorInterface
Aggregates: Printer, Fax
}

init
{
	println@Console( "Aggregator started" )()
}

main
{
	faxAndPrint( request )( response ) {
		  scope( fax_and_print ) {
					install( IOException => comp( print ); throw( Aborted ) );
					{

							scope( fax ) {
									println@Console("Faxing document to " + request.fax.destination )();
									fax@Fax( request.fax )()
							}
							|
							scope( print ) {
									println@Console("Printing document " + request.print.content )();
									print@Printer( request.print )( del_request )
									[
												this => del@Printer( del_request );
												println@Console("Rolling back printing..." )();
									 			println@Console("Deleted job " + del_request.jobId )()
									]
							}
					}
			}
	}
}
