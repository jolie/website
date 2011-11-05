type AuthenticateRequest: void {
  .username: string
  .password: string
}

type AuthenticateResponse: void 

interface AuthenticatorInterface {
RequestResponse:
	authenticate( AuthenticateRequest )( AuthenticateResponse )
	  throws AuthenticationFails
}