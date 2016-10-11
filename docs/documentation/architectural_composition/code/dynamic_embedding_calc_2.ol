// sum.ol --------------------------
inputPort Sum {
  Location:"local"
  Interfaces: OperationInterface
}

main {
  run( request )( response ) {
    response = request.x + request.y
  }
}
// ---------------------------------

// sub.ol --------------------------
// inputPort Sub ... 
main {
  run( request )( response ) {
    response = request.x - request.y
  }
}
// ---------------------------------

// mul.ol --------------------------
// inputPort Mul ... 
main {
  run( request )( response ) {
    response = request.x * request.y
  }
}
// ----------------------------------

// div.ol --------------------------
// inputPort Div ... 
main {
  run( request )( response ) {
    response = request.x / request.y
  }
}
// ----------------------------------
