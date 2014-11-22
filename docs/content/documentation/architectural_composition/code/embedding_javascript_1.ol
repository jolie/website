include "console.iol"

type TwiceRequest:void {
	.number: int
}

interface TwiceInterface {
RequestResponse:
	twice( TwiceRequest )( int )
}

outputPort TwiceService {
Interfaces: TwiceInterface
}

embedded {
JavaScript:
	"TwiceService.js" in TwiceService
}

main
{
	request.number = 5;
	twice@TwiceService( request )( response );
	println@Console( "Javascript 'twice' Service response: " + response )()
}
