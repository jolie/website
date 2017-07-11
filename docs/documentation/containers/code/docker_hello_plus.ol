interface HelloPlusInterface {
  RequestResponse: helloPlus( string )( string )
}

interface HelloInterface {
  RequestResponse: hello( string )( string )
}

constants {
  CUSTOM_MESSAGE = " :plus!"
}

execution{ concurrent }

outputPort Hello {
  Location: "socker://localhost:8000"
  Protocol: sodep
  Interfaces: HelloInterface
}

inputPort HelloPlus {
  Location: "socket://localhost:8001"
  Protocol: sodep
  Interfaces: HelloPlusInterface
}

main {
  helloPlus( request )( response ) {
    hello@Hello( request )( response );
    response = response + CUSTOM_MESSAGE
  }
}
