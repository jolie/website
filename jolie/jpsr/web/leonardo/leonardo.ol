/***************************************************************************
 *   Copyright (C) 2013 by Fabrizio Montesi <famontesi@gmail.com>          *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 *                                                                         *
 *   For details about the authors of this software, see the AUTHORS file. *
 ***************************************************************************/

include "console.iol"
include "file.iol"
include "string_utils.iol"
include "protocols/http.iol"
include "web/frontend/JpsrFrontend.iol"

include "config.iol"
include "../../config.iol"

execution { concurrent }

interface HTTPInterface {
RequestResponse:
	default(DefaultOperationHttpRequest)(undefined)
}

outputPort JpsrFrontend {
Interfaces: JpsrFrontendInterface
}

inputPort HTTPInput { 
Protocol: https {
	.keepAlive = false; // Do not keep connections open
	.debug = DebugHttp; 
	.debug.showContent = DebugHttpContent;
	.format -> format;
	.contentType -> mime;
	.statusCode -> statusCode;
	.redirect -> location;
	.default = "default";
	.ssl.keyStore = "keystore.jks";
	.ssl.keyStorePassword = KeystorePassword
}

Location: Location_Leonardo
Interfaces: HTTPInterface
Aggregates: JpsrFrontend
}

embedded {
Jolie:
	"../frontend/main.ol" in JpsrFrontend
}

init
{
	getServiceDirectory@File()( thisDir );
	documentRootDirectory = thisDir + "/" + WWWDirectory;
	format = "html"
}

define checkForMaliciousPath
{
	c = s.result[0];
	c.substring = "..";
	contains@StringUtils( c )( b );
	if ( b ) {
		throw( FileNotFound )
	};
	c.substring = ".svn";
	contains@StringUtils( c )( b );
	if ( b ) {
		throw( FileNotFound )
	}
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

			checkForMaliciousPath;

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
}

