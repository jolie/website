type LookForRequest: void {
  .service: string
  .coord: string
}

type LookForResponse: void {
  .row*: void {
    .name: string
    .coord: string
    .location: string
  }
}

interface RegisterInterface {
RequestResponse:
	lookFor( LookForRequest )( LookForResponse )
}