execution { concurrent }

type SumRequest:void {
	.x:int
	.y:int
}

interface SumInterface {
	RequestResponse: sum(SumRequest)(int)
}

inputPort MyInput {
	Location: "socket://localhost:8000/"
	Protocol: http
	Interfaces: SumInterface
}

main
{
	sum( request )( response ) {
	response = request.x + request.y
	}
}