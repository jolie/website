include "console.iol"
include "file.iol"
include "string_utils.iol"
include "protocols/http.iol"
include "../frontend/frontend.iol"
include "../news/news_service_interface.iol"

include "config.iol"
include "admin.iol"

execution { concurrent }

interface HTTPInterface {
RequestResponse:
	default(DefaultOperationHttpRequest)(undefined),
	getRss( void )( string )
}

outputPort Frontend {
Interfaces: FrontendInterface
}

outputPort NewsService {
	Interfaces: GetNewsInterface
}

inputPort HTTPInput { 
	Protocol: http {
		.keepAlive = false; // Do not keep connections open
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
	Aggregates: Frontend, NewsService
}

inputPort AdminInput {
Location: "socket://localhost:9000/"
Protocol: sodep
Interfaces: AdminInterface
}

embedded {
Jolie:
	"../frontend/frontend.ol" in Frontend,
	"../news/news_service.ol" in NewsService
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

	[ getRss()(response){
		getRss@NewsService()( response );
		format = "html"
	} ]{ nullProcess }
}

