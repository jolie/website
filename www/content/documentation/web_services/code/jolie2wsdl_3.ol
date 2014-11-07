type Type1: void {
	.msg: int
}

type Type2: void {
	.msg: string
}

interface MyInterface {
	RequestResponse:
		myOp( Type1 )( Type2 )
}