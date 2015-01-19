type PowRequest:void {
	.x:double
	.y:double
}

interface CalculatorIface {
RequestResponse:
	pow( PowRequest )( double )
}