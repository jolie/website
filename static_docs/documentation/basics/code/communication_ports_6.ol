//sumInterface.ol

type SumRequest: void {
	.number [ 2, * ]: int
}

interface SumInterface {
	RequestResponse: sum( SumRequest )( int )
}