type ConfirmEmailType:void {
	.sid:string
}

type RequestUserCreationType:void {
	.username:string
	.password:string
}

interface JpsrFrontendInterface {
RequestResponse:
	requestUserCreation(RequestUserCreationType)(void),
	confirmEmail(ConfirmEmailType)(void)
}
