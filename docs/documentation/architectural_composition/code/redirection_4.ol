include "SumInterface.iol"
include "console.iol"

outputPort Sum {
  /* the client calls the sum service which is located at the redirector socket://localhost:2002
  teh resource is identified by the suffix /!/Sum */
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
