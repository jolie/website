include "console.iol"

execution { concurrent }

interface SumServiceInterface {
  RequestResponse:
    operator
}

inputPort Sum {
  Location: "socket://localhost:8002/"
  Protocol: sodep
  Interfaces: SumServiceInterface
}

main
{
    operator( request )( result ) {
      result = int( request.x ) + int( request.y )
    }
}