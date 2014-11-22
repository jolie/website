include "console.iol"

type SumRequest:void {
	.x:int
	.y:int
}

interface SumInterface {
	RequestResponse: sum(SumRequest)(int)
}

outputPort SumService {
	Location: "socket://localhost:8000/"
	Protocol: http { .method = "get" }
	Interfaces: SumInterface
}

main
{
	request.x = 4;
	request.y = 2;
	sum@SumService( request )( response );
	println@Console( response )()
}
