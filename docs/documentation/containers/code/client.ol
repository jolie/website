include "console.iol"

interface HelloInterface {
  RequestResponse: hello( string )( string )
}

outputPort Hello {
  Location: "socket://localhost:8000"
  Protocol: sodep
  Interfaces: HelloInterface
}

main {
  hello@Hello( "hello" )( response );
  println@Console( response )()
}
