interface HelloInterface {
  RequestResponse: hello( string )( string )
}

execution{ concurrent }

inputPort Hello {
  Location: "socket://localhost:8000"
  Protocol: sodep
  Interfaces: HelloInterface
}

main {
  hello( request )( response ) {
    response = request
  }
}