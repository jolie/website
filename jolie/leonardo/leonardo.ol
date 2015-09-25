/***************************************************************************
 *   Copyright (C) 2013-2014 by Fabrizio Montesi <famontesi@gmail.com>     *
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
include "../frontend/frontend.iol"

include "config.iol"
include "virtual_hosts.iol"
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
	// .keepAlive = false; // Do not keep connections open
	.debug = DebugHttp; 
	.debug.showContent = DebugHttpContent;
	.format -> format;
	.contentType -> mime;
	.statusCode -> statusCode;
	.redirect -> location;
	.default = "default";
	.host -> host;
	.cacheControl.maxAge -> cacheMaxAge;
	.compressionTypes -> compressionTypes
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
	documentRootDirectory = WWWDirectory;
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

define applyTheme
{
	if ( response instanceof string ) {
		response.prefix = "<!--Themed-->";
		startsWith@StringUtils( response )( isThemed );
		undef( response.prefix );
		if ( isThemed ) {
			file.format = "text";
			file.filename = documentRootDirectory + "header.html";
			readFile@File( file )( header );
			file.format = "text";
			file.filename = documentRootDirectory + "footer.html";
			readFile@File( file )( footer );
			response = header + response + footer
		}
	}
}

courier HTTPInput {
	[ interface FrontendInterface( request )( response ) ] {
		forward( request )( response );
		applyTheme;
		compressionTypes = "*"
	}
}

main
{
	[ default( request )( response ) {
		scope( s ) {
			install( FileNotFound => println@Console( "File not found: " + file.filename )(); statusCode = 404 );

			// for javascript seo requests
			if( is_defined( request.data._escaped_fragment_ ) ){
				request.operation = request.data._escaped_fragment_
			};

			s = request.operation;
			s.regex = "\\?";
			split@StringUtils( s )( s );
			
			// Default page: index.html
			shouldAddIndex = false;
			if ( s.result[0] == "" ) {
				shouldAddIndex = true
			} else {
				e = s.result[0];
				e.suffix = "/";
				endsWith@StringUtils( e )( shouldAddIndex )
			};
			if ( shouldAddIndex ) {
				s.result[0] += "index.html"
			};

			checkForMaliciousPath;
			checkForHost;
			
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

			shouldCache = false;
			if ( s.result[0] == "image" ) {
				shouldCache = true
			} else {
				e = file.filename;
				e.suffix = ".js";
				endsWith@StringUtils( e )( shouldCache );
				if ( !shouldCache ) {
					e.suffix = ".css";
					endsWith@StringUtils( e )( shouldCache );
					if ( !shouldCache ) {
                                                e.suffix = ".woff";
                                                endsWith@StringUtils( e )( shouldCache )
                                        }
				}
			};
			
			if ( shouldCache ) {
				cacheMaxAge = 60 * 60 * 2 // 2 hours
			};

			readFile@File( file )( response );

			if ( file.format == "text" ) {
				applyTheme
			}
		}
	} ] { nullProcess }
	
	[ shutdown()() { nullProcess } ] { exit }
}

