include "console.iol"

execution { concurrent }

interface SubServiceInterface {
RequestResponse:
    operator
}

inputPort Sub {
  Location: "socket://localhost:8001/"
  Protocol: sodep
  Interfaces: SubServiceInterface
}

main
{
    operator( request )( result ) {
      result = int( request.x ) - int( request.y )
    }
}

