// sum.ol
include "OperationInterface.iol"

inputPort Op {
  Location:"local"
  Interfaces: OperationInterface
}

main {
  run( request )( response ) {
    response = request.x + request.y
  }
}

//sub.ol
[...]
main {
  run( request )( response ) {
    response = request.x - request.y
  }
}

//mul.ol
main {
  run( request )( response ) {
    response = request.x * request.y
  }
}

//div.ol
main {
  run( request )( response ) {
    response = request.x / request.y
  }
}
