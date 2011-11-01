include "locations.iol"
include "console.iol"

type PrintRequest_Auth:void {
	.job:int
	.content:string
	.key:string
}

type DelRequest_Auth:int {
	.key:string
}

type FaxRequest_Auth:void {
	.destination:string
	.content:string
	.key:string
}

interface ExtendedFaxInterface {
OneWay:
	fax(FaxRequest_Auth)
}

interface ExtendedPrinterInterface {
OneWay:
	print(PrintRequest_Auth),
	del(DelRequest_Auth)
RequestResponse:
	get_key(string)(string)
}


outputPort Aggregator {
Location: locationAggregator
Interfaces: ExtendedPrinterInterface, ExtendedFaxInterface
Protocol: sodep
}

main
{
	request.content = "Hello, Printer!";

	get_key@Aggregator( "username1" )( key );
	request.key = key;
	request.job = 1;
	print@Aggregator( request );
	println@Console("job printed!")();
	

	request.key = "Invalid";
	request.job = 3;
	print@Aggregator( request );

	faxRequest.key = key;
	faxRequest.destination = "123456789";
	faxRequest.content = "Hello, Fax!";
	fax@Aggregator( faxRequest )
}