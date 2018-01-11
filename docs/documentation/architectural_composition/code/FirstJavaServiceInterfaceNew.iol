type AsyncHelloWorldRequest: void {
  .message: string
  .sleep: int
}

type HelloWorldRequest: void {
  .message: string
}

type HelloWorldResponse: void {
  .reply: string
}

interface FirstJavaServiceInterface {
  RequestResponse:
    HelloWorld( HelloWorldRequest )( HelloWorldResponse )
  OneWay:
    AsyncHelloWorld( AsyncHelloWorldRequest )
}
