// interface.iol

type Fault_number_type: void{
	.number: int
	.fault_error: string
}

interface Guess {
	RequestResponse: guess throws fault_number( Fault_number_type )
}