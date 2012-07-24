/*
   Copyright 2008-2012 Fabrizio Montesi <famontesi@gmail.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

include "console.iol"
include "file.iol"
include "string_utils.iol"
include "protocols/http.iol"

include "config.iol"

execution { concurrent }

type LengthRequest:void {
	.item[1,*]:string
}

interface ExampleInterface {
RequestResponse: length(LengthRequest)(int)
}

interface HTTPInterface {
RequestResponse:
	default(DefaultOperationHttpRequest)(undefined)
}

inputPort HTTPInput {
Protocol: http {
	.keepAlive = 0; // Do not keep connections open
	.debug = DebugHttp; 
	.debug.showContent = DebugHttpContent;
	.format -> format;
	.contentType -> mime;

	.default = "default"
}
Location: Location_Leonardo
Interfaces: HTTPInterface, ExampleInterface
}

init
{
	if ( is_defined( args[0] ) ) {
		documentRootDirectory = args[0]
	}
}

main
{
	[ default( request )( response ) {
		scope( s ) {
			install( FileNotFound => println@Console( "File not found: " + file.filename )() );

			s = request.operation;
			s.regex = "\\?";
			split@StringUtils( s )( s );
			
			// Default page
			if ( s.result[0] == "" ) {
				s.result[0] = DefaultPage
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

	[ length( request )( response ) {
		response = 0;
		for( i = 0, i < #request.item, i++ ) {
			length@StringUtils( request.item[i] )( l );
			response += l
		}
	} ] { nullProcess }
}
