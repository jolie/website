include "console.iol"

execution{ concurrent }

interface JavaServiceInterface {
RequestResponse:
	start( string )( int )
}

interface EmbedderInterface {
OneWay:
	run( string )
}

outputPort JavaService {
Interfaces: JavaServiceInterface
}

embedded {
	Java:
		"jolie.example.FourthJavaService" in JavaService
}

inputPort Embedder {
Location: "socket://localhost:8001"
Protocol: sodep
Interfaces: EmbedderInterface
}

main
{	
  run( request );
  start@JavaService( request )( response );
  println@Console("Received counter " + response )()
}