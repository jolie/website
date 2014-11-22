include "locations.iol"
include "printer.iol"
include "fax.iol"
include "console.iol"
include "logger.iol"

execution { concurrent }

type AuthenticationData:void {
	.key:string
}

interface extender AuthInterfaceExtender {
RequestResponse:
	*(AuthenticationData)(void)
OneWay:
	*(AuthenticationData)
}

interface AggregatorInterface {
RequestResponse:
	get_key(string)(string)
}

outputPort Printer1 {
Location: Location_Printer1
Protocol: sodep
Interfaces: PrinterInterface
}

outputPort Printer2 {
Location: Location_Printer2
Protocol: sodep
Interfaces: PrinterInterface
}

outputPort Logger {
Location: Location_Logger
Protocol: sodep
Interfaces: LoggerInterface
}

outputPort Fax {
Location: Location_Fax
Protocol: sodep
Interfaces: FaxInterface
}

inputPort AggregatorInput {
Location: Location_Aggregator
Protocol: sodep
Interfaces: AggregatorInterface
Aggregates: { Printer1, Printer2 } with AuthInterfaceExtender, Fax
}

courier AggregatorInput {
	[ interface PrinterInterface( request ) ] {
		if ( request.key == "0000" ) {
			log@Logger( "Request for printer service 1" );
			forward Printer1( request )
		} else if ( request.key == "1111" ) {
			log@Logger( "Request for printer service 2" );
			forward Printer2( request )
		} else {
			log@Logger( "Request with invalid key: " + request.key )
		}
	}

	[ interface FaxInterface( request ) ] {
		log@Logger( "Received a request for fax service" );
		forward ( request )
	}
}

init
{
	println@Console( "Aggregator started" )()
}

main
{
	get_key( username )( key ) {
		if ( username == "username1" ) {
			key = "0000"
		} else if ( username == "username2" ) {
			key = "1111"
		} else {
			key = "XXXX"
		};
		log@Logger( "Sending key for username " + username )
	}
}
