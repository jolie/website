include "console.iol"
include "file.iol"
include "string_utils.iol"
include "runtime.iol"
include "./public/interfaces/AssistanceInterface.iol"


execution { concurrent }

interface HTTPInterface {
RequestResponse:
	default(undefined)(undefined)
}

constants {
  documentRootDirectory="./",
  cssDirectory = "./css/"
}

outputPort Assistance {
Interfaces: AssistanceInterfaceEmbedded
}

embedded {
Jolie:
	// set here the jewel frontend if necessary
	"main_assistance.ol" in Assistance
	
}

inputPort HTTPInput {
Protocol: http {
	.keepAlive = 0; // Do not keep connections open
	.format -> format;
	.contentType -> mime;
	.default = "default"
}
Location: "socket://localhost:8001"
Interfaces: HTTPInterface
Aggregates: Assistance
}

define setMime {
	getMimeType@File( file.filename )( mime );
	println@Console( file.filename +":" + mime )();
	mime.regex = "/";
	split@StringUtils( mime )( s );
	if ( s.result[0] == "text" ) {
		file.format = "text";
		format = "html"
	} else {
		file.format = format = "binary"
	}
}

main
{
	// Do _not_ modify the behaviour of the default operation.
	[ default( request )( response ) {
           scope( s ) {
			//valueToPrettyString@StringUtils( request )( str );
			//println@Console( str )();
			install( FileNotFound =>
					css = filename;
					css.regex = "\\.";
					split@StringUtils( css )( css );
					if ( css.result[1] == "css" ) {
						scope( css2 ) {
							install( FileNotFound => println@Console("File not Found " + file.filename )() );
							file.filename = cssDirectory + filename;
							setMime;
							readFile@File( file )( response )
						}
					} 
			);
			s = request.operation;
			s.regex = "\\?";
			split@StringUtils( s )( s );
			filename = s.result[0];	// used for retrieving css files within fault handler
			file.filename = documentRootDirectory + s.result[0];
			setMime;
				
			readFile@File( file )( response )
			
		}
	} ] { nullProcess }
}
