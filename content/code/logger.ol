include "locations.iol"
include "logger.iol"
include "console.iol"

execution { concurrent }

inputPort LoggerInput {
Location: locationLogger
Protocol: sodep
Interfaces: LoggerInterface
}

main
{
	log( request );
	println@Console( request )()
}