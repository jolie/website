type PrintRequest:void {
	.job:int
	.content:string
}

interface PrinterInterface {
RequestResponse:
	print( PrintRequest )( void )
OneWay:
	del(int)
}
