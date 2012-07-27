include "console.iol"
include "runtime.iol"

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

inputPort Embedder {
Location: "socket://localhost:8001"
Protocol: sodep
Interfaces: EmbedderInterface
}

main
{	
  run( request );
  embedInfo.type = "Java";
  embedInfo.filepath = "jolie.example.FourthJavaService";
  loadEmbeddedService@Runtime( embedInfo )( JavaService.location );
  start@JavaService( request )( response );
  println@Console("Received counter " + response )()
}