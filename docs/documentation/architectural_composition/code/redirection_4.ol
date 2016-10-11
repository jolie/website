include "SumInterface.iol"
include "console.iol"

outputPort Sum {
  /* the client calls the Sum service by contacting redirector
  at address "socket://localhost:2002" and specifying the correspondent
  resource name with "/!/Sum" */
  Location: "socket://localhost:2002/!/Sum"
  Protocol: sodep
  Interfaces: SumInterface
}

main {
  rq.x = double( args[ 0 ] );
  rq.y = double( args[ 1 ] );
  sum@Sum( rq )( result );
  println@Console( result )()
}