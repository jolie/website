include "console.iol"

interface ServiceInterface {
  RequestResponse:
    operator
}

constants {
  endpoint_base = "socket://localhost:8000/!/"
}

outputPort OperatorService {
  Protocol: sodep
  Interfaces: ServiceInterface
}

main
{
  registerForInput@Console()();
  println@Console( "Insert a number" )();
  in( request.x );
  println@Console( "Insert another number" )();
  in( request.y );
  println@Console("Type add for performing sum, subtraction otherwise:")();
  in( answer );
  if ( answer=="add" ) {
      OperatorService.location = endpoint_base + "Sum"
  } else {
      OperatorService.location = endpoint_base + "Sub"
  };
  operator@OperatorService( request )( response );
  println@Console( response )()
}