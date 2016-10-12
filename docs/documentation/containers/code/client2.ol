include "console.iol"

interface HelloPlusInterface {
  RequestResponse: helloPlus( string )( string )
}

outputPort HelloPlus {
  Location: "socket://localhost:8001"
  Protocol: sodep
  Interfaces: HelloPlusInterface
}

main {
  helloPlus@HelloPlus( "hello" )( response );
  println@Console( response )()
}
