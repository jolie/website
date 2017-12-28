type HelloWorldRequest: void {
  .message: string
}

type HelloWorldResponse: void {
  .reply: string
}

interface FirstJavaServiceInterface {
  RequestResponse:
    HelloWorld( HelloWorldRequest )( HelloWorldResponse )
}
