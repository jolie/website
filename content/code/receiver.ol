include "console.iol"

interface MyFirstInterface {
  RequestResponse:
  printMessage
}

inputPort MyFirstInputPort {
    Location: "socket://localhost:8090"
    Protocol: sodep
    Interfaces: MyFirstInterface
}

main {
  printMessage( request )( response ) {
    println@Console( request )();
    response = "Message printed!"
  }
}