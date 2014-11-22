include "twiceInterface.iol"
 
inputPort LocalIn {
	Location: "local"
	Interfaces: TwiceInterface
}
 
main
{
    twice( number )( result ) {
        result = number * 2
    }
}