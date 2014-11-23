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
include "../news/news_service_interface.iol"

include "virtual_hosts.iol"
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
	.default = "default";
	.host -> host
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

			readFile@File( file )( response )
		}
	} ] { nullProcess }

	[ shutdown()() { nullProcess } ] { exit }

	[ getRss()( response ){
		getRss@NewsService()( response );
		format = "html"
	} ]{ nullProcess }
}

