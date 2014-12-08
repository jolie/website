type LengthRequest: void{
	.item[ 1, * ]: string
}

interface ExampleInterface {
	RequestResponse:
		length( LengthRequest )( int )
}