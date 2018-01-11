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

type WrongMessageFaultType: void {
  .msg: string
}

interface FirstJavaServiceInterface {
  RequestResponse:
    HelloWorld( HelloWorldRequest )( HelloWorldResponse ) throws WrongMessage( WrongMessageFaultType )
  OneWay:
    AsyncHelloWorld( AsyncHelloWorldRequest )
}
