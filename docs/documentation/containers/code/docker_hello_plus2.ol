interface HelloPlusInterface {
  RequestResponse: helloPlus( string )( string )
}

interface HelloInterface {
  RequestResponse: hello( string )( string )
}

include "dependencies.iol"

execution{ concurrent }

outputPort Hello {
  Location: JDEP_HELLO_LOCATION
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
    response = response + JDEP_CUSTOM_MESSAGE
  }
}
