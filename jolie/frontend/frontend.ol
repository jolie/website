/***************************************************************************
 *   Copyright (C) 2013 by Saverio Giallorenzo                             *
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

include "frontend.iol"
include "file.iol"
include "string_utils.iol"
include "console.iol"
include "blog_reader/blog_reader.iol"
include "json_utils.iol"

execution { concurrent }

inputPort FrontendInput {
Location: "local"
Interfaces: FrontendInterface
}

outputPort BlogReader {
Interfaces: BlogReaderInterface
}

embedded {
Jolie:
	"blog_reader/main.ol" in BlogReader
}

define buildEntryHtml
{
	html = "<!--Themed-->";
	entry -> blogsContent.entry[i];
	lastTimestamp = 0;
	for( i = 0, i < #blogsContent.entry, i++ ) {
		if ( entry.timestamp != lastTimestamp ) {
			html += "<p class=\"BlogDateGroup\">" + entry.date + "</p>";
			lastTimestamp = entry.timestamp
		} else if ( i > 0 ) {
			html += "<div class=\"BlogEntrySeparator\"></div>"
		};
		html += "<div class=\"BlogEntry\">"
		+ "<p class=\"BlogEntryAuthor\">Posted by <a href=\"" + entry.links.blog + "\">" + entry.author + "</a></p>"
		+ "<p class=\"BlogEntryTitle\"><a href=\"" + entry.links.entry + "\">" + entry.title + "</a></p>"
		+ "<div class=\"BlogEntryContent\">" + entry.content + "</div>"
		+ "</div>"
	}
}

init
{
	with( newsBlog ) { 
		.url = "http://jolie-lang.blogspot.com/";
		.binding.location = "socket://jolie-lang.blogspot.com:80/feeds/posts/default";
		.binding.protocol = "http"
	};	
	with( planetBlogs[0] ) {
		.url = "http://fmontesi.blogspot.com/";
		.binding.location = "socket://fmontesi.blogspot.com:80/feeds/posts/default/-/jolie";
		.binding.protocol = "http"
	};
	with( planetBlogs[1] ) {
		.url = "http://claudioguidi.blogspot.com/";
		.binding.location = "socket://claudioguidi.blogspot.it:80/feeds/posts/default/-/jolie";
		.binding.protocol = "http"
	}
}

main
{
	[ documentationMenu()( menu ) {
		f.filename = "../../docs/documentation/menu.json";
		f.format = "json";
		readFile@File( f )( menu );
		
		listRequest.directory = "../../docs/documentation/jsl/";
		listRequest.regex = ".+\\.html";
		list@File( listRequest )( listResult );
		if ( #listResult.result > 0 ) {
			j = #menu.topics;
			apiTopic -> menu.topics[ j ];
			apiTopic.label = "Standard Library API";

			for( i = 0; z = 0, i < #listResult.result, i++ ) {
				match = listResult.result[ i ];
				match.regex = "(.+)\\.html";
				match@StringUtils( match )( matchResult );
				if ( matchResult.group[1] != "index" ) { // Do not include index.html
					apiTopic.children[ z ].label = matchResult.group[1];
					apiTopic.children[ z ].url = "jsl/" + matchResult.group[1] + ".html";
					z++
				}
			}
		};
		getJsonString@JsonUtils( menu )( menu )
	} ] { nullProcess }

	[ getRss()( response ) {
		// getRss@NewsService()( response )
		nullProcess
	} ] { nullProcess }
	
	[ news()( html ) {
		request.blogs -> newsBlog;
		readBlogs@BlogReader( request )( blogsContent );
		buildEntryHtml
	} ] { nullProcess }
	
	[ planet()( html ) {
		request.blogs -> planetBlogs;
		readBlogs@BlogReader( request )( blogsContent );
		buildEntryHtml
	} ] { nullProcess }
}