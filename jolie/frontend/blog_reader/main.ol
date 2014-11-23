/***************************************************************************
 *   Copyright (C) 2014 by Fabrizio Montesi <famontesi@gmail.com>          *
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
include "string_utils.iol"
include "xml_utils.iol"
include "runtime.iol"
include "time.iol"
include "quicksort.iol"
include "blog_reader.iol"

constants {
	BlogRefreshTimeout = 60000 // 1 min
}

execution { concurrent }

interface BlogInterface {
RequestResponse: getAtom(undefined)(undefined)
}

outputPort Blog {
Interfaces: BlogInterface
}

interface LocalInterface {
OneWay:
	timeout(void)
RequestResponse:
	fillCache(Binding)(void),
}

inputPort BlogReaderInput {
Location: "local"
Interfaces: BlogReaderInterface, LocalInterface
}

outputPort Self {
Interfaces: LocalInterface
}

outputPort Quicksort {
Interfaces: QuicksortInterface
}

embedded {
Jolie:
	"quicksort.ol" in Quicksort
}

init
{
	getLocalLocation@Runtime()( Self.location )
}

define fetchEntries
{
	scope( fetch ){
		install( IOException => 
			println@Console( "IOException fetching " + Blog.location )()
		);

		date.regex = "(\\d{4})-(\\d{2})-(\\d{2})";
		atomEntry -> atom.entry[ atomEntryIndex ];
		getAtom@Blog()( atom );
		for( atomEntryIndex = 0, atomEntryIndex < #atom.entry, atomEntryIndex++ ) {
			cacheEntryIndex = #cacheEntries;
			with( cacheEntries[ cacheEntryIndex ] ){
				.title = atomEntry.title;
				.author = atomEntry.author.name;
				if( atomEntry.content.("@Attributes").type == "html" ) {
					.text = "<h1>" + atomEntry.title + "</h1>" + atomEntry.content
				} else { .text = "Unsupported content type." };

				date = atomEntry.updated;
				find@StringUtils( date )( aDate );
				.timestamp = int( aDate.group[1] + aDate.group[2] + aDate.group[3] );
				.date = aDate.group[2] + "/" + aDate.group[3] + "/" + aDate.group[1]
			}
		}
	}
}

define addEntriesToResponse
{
	for( entryIdx = 0, entryIdx < #blogCache.entry, entryIdx++ ) {
		response.entry[#response.entry] << blogCache.entry[entryIdx]
	}
}

init
{
	setNextTimeout@Time( BlogRefreshTimeout )
}

main
{
	[ readBlogs( request )( response ) {
		for( blog -> request.blogs[ blogIdx ]; blogIdx = 0, blogIdx < #request.blogs, blogIdx++ ) {
			blogCache -> global.cache.(blog.location);
			if ( !is_defined( global.cache.(blog.location) ) ) {
				fillCache@Self( blog )()
			};
			addEntriesToResponse;
			quicksort@Quicksort( response )( response )
		}
	} ] { nullProcess }

	[ fillCache( Blog )() {
		if ( Blog.protocol == "http" ) {
			Blog.protocol.osc.getAtom.alias = " "
		};
		fetchEntries;
		synchronized( Cache ) {
			global.cache.(Blog.location).entry << cacheEntries;
			global.cache.(Blog.location).binding << Blog
		}
	} ] { nullProcess }

	[ timeout() ] {
		foreach( blogLoc : global.cache ) {
			fillCache@Self( global.cache.(blogLoc).binding )()
		};
		setNextTimeout@Time( BlogRefreshTimeout )
	}
}

