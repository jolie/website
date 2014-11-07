type Type1: int {
	.msg: string
}

type Type2: string {
	.msg: string
}

interface MyInterface {
	myOp( Type1 )( Type2 )
}