type register: void {
	.message: string
}

interface RegInterface {
	RequestResponse: register( void )( response )
}