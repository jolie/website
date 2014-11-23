include "console.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "html_utils.iol"
include "news_service_interface.iol"
include "quicksort_interface.iol"
include "atom_reader_interface.iol"


inputPort NewsServiceInput {
	Location: "local"
	Interfaces: GetNewsInterface
}

outputPort MarkedService {
	Interfaces: MarkedInterface
}

outputPort ToMarkdownService {
	Interfaces: ToMarkdownInterface
}

outputPort QuicksortService {
  Interfaces: ArticleQuickSortInterface
}

outputPort AtomNewsFetcher {
Interfaces: AtomNewsFetcherInterface
}


embedded {
JavaScript:
	"../news/marked.js" in MarkedService,
	"../news/to_markdown.js" in ToMarkdownService,
Jolie:
	"../news/quicksort.ol" in QuicksortService,
	"../news/atom_reader.ol" in AtomNewsFetcher
}

execution { concurrent }

constants {
	DEFAULT_NEWS_RANGE = 10
}


main
{
	[ getNews( newsRequest )( response ){
		scope( s ){
			install( IOException FileNotFound => 
				println@Console( "Error on: " + filename )();
				statusCode = 500
			);

			// get on-site news
			listRequest.directory = NEWS_FOLDER;
			listRequest.regex = "\\d+_\\d\\.xml";
			listRequest.order.byname = true;
			list@File( listRequest )( newsFiles );
			
			newsRange = DEFAULT_NEWS_RANGE;
			if( newsRequest.number > 0 ){
				newsRange = newsRequest.number
			};
			
			// initialise array of news
			// the ordering is descending, from the latest to the oldest
			if( #newsFiles.result > newsRange ) { localNewsRange = newsRange } 
				else { localNewsRange = #newsFiles.result	};
			for( i = ( #newsFiles.result-1 ) , i >= (#newsFiles.result - localNewsRange ), i-- ){
				readFileReq.filename = NEWS_FOLDER + "/" + newsFiles.result[ i ];
				readFile@File( readFileReq )( article );
				xmlToValue@XmlUtils( article )( a );
				d=a.date;
				d.regex="/";
				split@StringUtils( d )( d );
				date=int( d.result[2]+d.result[1]+d.result[0] );
				undef( d );
				undef( a );
				index = #news.article;
				news.article[ index ] = date;
				news.article[ index ].article = article
			};

			getNews@AtomNewsFetcher()( fNews );
			for (i=0, i<#fNews.article, i++) {
			  with( fNews.article[ i ] ){
			    index = #news.article;
			    news.article[ index ] = fNews.article[ i ];
			    news.article[ index ].article = "<article>";
			    // escapeHTML@HTMLUtils( .title )( .title );
			  	news.article[ index ].article += "<title>" 	+ .title 	+ "</title> ";
			    news.article[ index ].article += "<author>" + .author + "</author> ";
			    news.article[ index ].article += "<date>" 	+ .date 	+ "</date> ";
			    
			    undef( tmp );
			    tmp.text = .text;
			    println@Console( "Sending for conversion" )();
			    convertToMarkdown@ToMarkdownService( tmp )( .text );
			    undef( tmp );
			    tmp = .text;
			    tmp.replacement = "";
			    tmp.regex = "(\\<.*?\\>|&nbsp;|&lt;.*?&gt;)";
			    replaceAll@StringUtils( tmp )( .text );
			    news.article[ index ].article += "<text>" 	+ .text 	+ "</text>";
			    news.article[ index ].article += "</article>"
			  }
			};

			articleQuickSort@QuicksortService( news )( news );

			// create response
			response = "<news>";
			for( i=0, i<newsRange, i++ ){
				response += news.article[ i ].article
			};
			response += "</news>";
			statusCode = 200
		}
	}]{ nullProcess }

	[ getRss( newsRequest )( response ){
		scope( s ){
			install( IOException FileNotFound => 
				println@Console( "Error on: " + filename )();
				statusCode = 500
			);

			listRequest.directory = NEWS_FOLDER;
			listRequest.regex = "\\d+_\\d\\.xml";
			list@File( listRequest )( listResponse );
			newsRange = #listResponse.result;
			if( newsRequest.number > 0 &&
				#newsRage > newsRequest.number ){
				newsRange = newsRequest.number
			};
			response = "<?xml version=\"1.0\" encoding=\"utf-8\"?><rss version=\"2.0\">"+
							"<channel><title>Jolie Website</title><link>http://www.jolie-lang.org</link>"+
							"<description>The Jolie Website News</description>";
			for( i = 0, i < newsRange, i++ ){
				readFileReq.filename = NEWS_FOLDER + "/" + listResponse.result[ i ];
				readFile@File( readFileReq )( article );
				xmlToValue@XmlUtils( article )( article );
				length@StringUtils( article.text )( article.text.length );
					if( article.text.length > 0 ){
						with ( article ){
							markedReq.text = .text;
							marked@MarkedService( markedReq )( .text );
							escapeHTML@HTMLUtils( .text )( .text );
						article += "<item>" +
										"<title>" + .title + "</title>" +
										"<link>http://www.jolie-lang.org/?top_menu=news</link>" +
										"<description>" + .text + "</description>" +
									"</item>"
						}
					};
				response += article
			};
			response += "</channel></rss>";
			statusCode = 200

		}
	}]{ nullProcess }

}
