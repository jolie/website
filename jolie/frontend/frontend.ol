/*
 *   Copyright (C) 2013 by Saverio Giallorenzo                             *
 *   Copyright (C) 2014-2020 by Fabrizio Montesi <famontesi@gmail.com>          *
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
 */

include "frontend.iol"
include "file.iol"
include "string_utils.iol"
include "console.iol"
include "blog_reader/blog_reader.iol"
include "slideshare/SlideShareInterface.iol"
include "json_utils.iol"
include "../leonardo/config.iol"

execution { concurrent }

outputPort SlideShare {
Interfaces: SlideShareInterface
}

outputPort BlogReader {
Interfaces: BlogReaderInterface
}

inputPort FrontendInput {
Location: "local"
Interfaces: FrontendInterface
Aggregates: SlideShare
}

embedded {
Jolie:
	"blog_reader/main.ol" in BlogReader,
	"slideshare/slideshare.ol" in SlideShare,
	"dump_stats.ol"
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
		+ "<div id=\"readmore" + i + "\" class=\"BlogEntryContent\">" + entry.content + "</div>"
		+ "<div class=\"BlogEntryContentReadMore\"><a id=\"readmore" + i + "button\" onclick=\"readmore('readmore" + i + "')\">[...]</a></div>"
		+ "</div>"
	}
}

init
{
	with( newsBlog ) {
		.url = "https://jolie.github.io/news";
		.binding.location = "socket://jolie.github.io:443/news/feed-jolie.xml";
		.binding.protocol = "https";
		.binding.protocol.ssl.protocol = "TLSv1.2"
	};
	with( planetBlogs[0] ) {
		.url = "https://fmontesi.github.io/";
		.binding.location = "socket://fmontesi.github.io:443/feed-jolie.xml";
		.binding.protocol = "https";
		.binding.protocol.ssl.protocol = "TLSv1.2"
	};
	with( planetBlogs[1] ) {
		.url = "http://claudioguidi.blogspot.com/";
		.binding.location = "socket://claudioguidi.blogspot.com:80/feeds/posts/default/-/jolie";
		.binding.protocol = "http"
	};
	with( planetBlogs[2] ) {
		.url = "https://thesave.github.io/";
		.binding.location = "socket://thesave.github.io:443/feed.xml";
		.binding.protocol = "https";
		.binding.protocol.ssl.protocol = "TLSv1.2"
	};
	with( planetBlogs[3] ) {
		.url = "http://jolie-practitioner.blogspot.com/";
		.binding.location = "socket://jolie-practitioner.blogspot.com:80/feeds/posts/default/-/jolie";
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
		listRequest.order.byname = true;
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
		for( blog in newsBlog ) {
			request.blogs[#request.blogs] << blog
		}
		for( blog in planetBlogs ) {
			request.blogs[#request.blogs] << blog
		}
		// TODO
		readBlogs@BlogReader( request )( response )		
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

	[ documentation()( html ) {
		request.username_for = "JolieLang";
		scope( slideshare ) {
			install( default => nullProcess );
			get_slideshows_by_user@SlideShare( request )( response )
		};

		// gets static part of documentation page from www folder
		f.filename = WWWDirectory + "documentation.html";
		readFile@File( f )( html );
		iofReq = html;
		iofReq.word = "<!--dynamic part-->";
		indexOf@StringUtils( iofReq )( html.end );
		undef( iofReq );
		html.begin = 0;
		substring@StringUtils( html )( html );

		html += "<h2 id=\"tutorials-presentations\">Presentations</h2>";
		for( x = 0, x < #response.Slideshow, x++ ) {
			sp_rq = response.Slideshow[ x ].Embed;
			sp_rq.regex = "</iframe>";
			split@StringUtils( sp_rq )( sp_rs );
			if ( x % 2 == 0 ) {
				html += "<div class=\"col-xs-12 row slide\">"
			};
// 			html += "<div class=\"col-xs-6\">"
// 				+ "<p class=\"slide-title\">" + response.Slideshow[ x ].Title + "</p>"
// 				+ "<p class=\"slide-created\">" + response.Slideshow[ x ].Created + "</p>"
// 				+ "<div class=\"col-xs-12 row vertical-align\">"
			html += "<div class=\"col-xs-6 slide-embed vertical-align\">" + sp_rs.result[ 0 ] + "</iframe></div>";
// 				+ "<div class=\"col-xs-6 slide-description vertical-align\">\"" + response.Slideshow[ x ].Description + "\"</div>"
// 				+ "</div>";
			if ( x % 2 == 1 || x == #response.Slideshow - 1 ) {
				html += "<div class=\"clearfix\"></div></div>"
			}
		};

		undef( request );
		request.blogs -> planetBlogs;
		request.tag = "tutorials";
		readBlogs@BlogReader( request )( blogsContent );
		html += "<h2 id=\"tutorials-blogs\">Articles</h2><ul>";
		for( i = 0, i < #blogsContent.entry, i++ ) {
			html += "<li><a href=\"" + blogsContent.entry[i].links.entry + "\">"
				+ blogsContent.entry[i].title
				+ "</a></li>"
		};
		html += "</ul>"
	}] { nullProcess }
}
