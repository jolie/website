//interface.iol

type LoginRequest: void {
	.name: string
}

type OpMessage: void{
	.sid: string
	.message?: string
}

interface PrintInterface {
	RequestResponse: login(LoginRequest)(OpMessage)
	OneWay: print(OpMessage), logout(OpMessage)
}