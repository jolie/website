include "console.iol"
include "file.iol"
include "string_utils.iol"
include "protocols/http.iol"
include "../frontend/frontend.iol"

include "config.iol"
include "admin.iol"

execution { concurrent }

interface HTTPInterface {
RequestResponse:
	default(DefaultOperationHttpRequest)(undefined)
}

outputPort Frontend {
Interfaces: FrontendInterface
}

inputPort HTTPInput { 
Protocol: http {
	.keepAlive = true; // Do not keep connections open
	.debug = DebugHttp; 
	.debug.showContent = DebugHttpContent;
	.format -> format;
	.contentType -> mime;
	.statusCode -> statusCode;
	.redirect -> location;
	.default = "default"
}
Location: Location_Leonardo
Interfaces: HTTPInterface
Aggregates: Frontend
}

inputPort AdminInput {
Location: "socket://localhost:9000/"
Protocol: sodep
Interfaces: AdminInterface
}

embedded {
Jolie:
	"../frontend/frontend.ol" in Frontend
}

init
{
	documentRootDirectory = WWWDirectory
}

main
{

	[ default( request )( response ) {
		scope( s ) {
			install( FileNotFound => println@Console( "File not found: " + file.filename )(); statusCode = 404 );

			s = request.operation;
			s.regex = "\\?";
			split@StringUtils( s )( s );
			
			// Default page: index.html 
			if ( s.result[0] == "" ) {
				s.result[0] = "index.html"
			};

			file.filename = documentRootDirectory + s.result[0];

			getMimeType@File( file.filename )( mime );
			mime.regex = "/";
			split@StringUtils( mime )( s );
			if ( s.result[0] == "text" ) {
				file.format = "text";
				format = "html"
			} else {
				file.format = format = "binary"
			};

			readFile@File( file )( response )
		}
	} ] { nullProcess }

	[ shutdown()() { nullProcess } ] { exit }
}

