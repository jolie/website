include "locations.iol"
include "printer.iol"
include "fax.iol"
include "console.iol"
include "logger.iol"

execution { concurrent }

type AuthenticationData:void {
	.key:string
}

interface extender AuthenticationInterfaceExtender {
RequestResponse:
	*(AuthenticationData)(void) throws AccessDenied
OneWay:
	*(AuthenticationData)
}

interface AggregatorInterface {
RequestResponse:
	get_key(string)(string)
}

outputPort Printer {
Location: locationPrinter
Protocol: sodep
Interfaces: PrinterInterface
}

outputPort Logger {
Location: locationLogger
Protocol: sodep
Interfaces: LoggerInterface
}

outputPort Fax {
Location: locationFax
Protocol: sodep
Interfaces: FaxInterface
}

inputPort AggregatorInput {
Location: locationAggregator
Protocol: sodep
Interfaces: AggregatorInterface
Aggregates: Printer with AuthenticationInterfaceExtender, 
	    Fax with AuthenticationInterfaceExtender
}

courier AggregatorInput {
	[ interface PrinterInterface( request )( response ) ] {
		if ( request.key == "0000" ) {
			log@Logger( "Request for printer service 1" );
			forward Printer( request )( response )
		} else {
			log@Logger( "Request with invalid key: " + request.key );
			throw( AccessDenied )
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
		} else {
			key = "XXXX"
		};
		log@Logger( "Sending key for username " + username )
	}
}
