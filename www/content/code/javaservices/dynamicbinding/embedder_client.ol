include "console.iol"

interface EmbedderInterface {
OneWay:
	run( string )
}



outputPort Embedder {
Location: "socket://localhost:8001"
Protocol: sodep
Interfaces: EmbedderInterface
}

main
{	
  for ( i = 0, i < 10, i++ ) {
    request = "Hello!";
    run@Embedder( request )
  }
}