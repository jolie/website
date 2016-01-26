include "fax.iol"
include "console.iol"
 
execution { concurrent }
 
type AuthenticationData: void {
    .key:string
}
 
interface extender AuthInterfaceExtender {
	OneWay:
	    *(AuthenticationData)
}
 
interface AggregatorInterface {
RequestResponse:
    get_key(string)(string)
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
	Aggregates: Fax with AuthInterfaceExtender
}
 
courier AggregatorInput {
	[interface FaxInterface( request )] {
        if ( key == "1111" ){
        	forward ( request )
        }
    }
}
 
main
{
    get_key( username )( key ) {
    	if ( username == "username" ) {
    		key = "1111"
        } else {
            key = "XXXX"
        }
    }
}
