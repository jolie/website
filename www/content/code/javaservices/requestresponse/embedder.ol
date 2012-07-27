include "console.iol"

interface JavaServiceInterface {
OneWay:
	start
RequestResponse:
	write
}

interface EmbedderInterface {
RequestResponse:
	initialize
}

outputPort JavaService {
Interfaces: JavaServiceInterface
}

embedded {
	Java:
		"jolie.example.ThirdJavaService" in JavaService
}

inputPort Embedder {
Location: "local"
Interfaces: EmbedderInterface
}

main
{	
	request.message="Hello world!";
	start@JavaService( request );
	initialize( request )( response_initialize ){
		response_initialize = "This is the initialization"
	};
	write@JavaService( request )( response_write );
	println@Console( response_write.message )()
}