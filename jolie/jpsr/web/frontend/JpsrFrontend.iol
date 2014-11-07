type ConfirmEmailType:void {
	.sid:string
}

type RequestUserCreationType:void {
	.username:string
	.password:string
}

interface JpsrFrontendInterface {
RequestResponse:
	requestUserCreation(RequestUserCreationType)(string),
	confirmEmail(ConfirmEmailType)(string)
}
