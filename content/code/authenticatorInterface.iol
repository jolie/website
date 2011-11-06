type AuthenticateRequest: void {
  .username: string
  .password: string
}

type AuthenticateResponse: void 

type GetTutorLocationRequest: void {
  .username: string
}

type GetTutorLocationResponse: void {
  .location: string
}

type GetTutorDirectorLocationRequest: void {
  .username: string
}

type GetTutorDirectorLocationResponse: void {
  .location: string
}

interface AuthenticatorInterface {
RequestResponse:
	authenticate( AuthenticateRequest )( AuthenticateResponse )
	  throws AuthenticationFails,
      
	getTutorLocation( GetTutorLocationRequest )( GetTutorLocationResponse ),

	getTutorDirectorLocation( GetTutorDirectorLocationRequest )( GetTutorDirectorLocationResponse )
}