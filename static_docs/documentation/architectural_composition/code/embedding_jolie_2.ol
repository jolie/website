include "twiceInterface.iol"
include "console.iol"

outputPort TwiceService {
	Interfaces: TwiceInterface
}

embedded {
	Jolie: "twice_service.ol" in TwiceService
}

main
{
	twice@TwiceService( 5 )( response );
	println@Console( response )()
}

