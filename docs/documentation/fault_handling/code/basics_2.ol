// interface.iol

type NumberExceptionType: void{
	.number: int
	.exceptionMessage: string
}

interface GuessInterface {
	RequestResponse: guess throws NumberException( NumberExceptionType )
}