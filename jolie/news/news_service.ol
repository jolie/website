include "console.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "news_service_interface.iol"

inputPort NewsService {
  Location: "socket://localhost:8001/"
  Protocol: http { 
  		.format = "html";
  		.statusCode -> statusCode
  	 }
  Interfaces: PostNewsInterface
}

inputPort NewsServiceInput {
	Location: "local"
	Interfaces: GetNewsInterface
}

execution { concurrent }

constants {
	NEWS_FOLDER = "../news/news_storage" 
}

main
{
	[ postNews( article )( response ){
		scope( s ){
			install( 
				FileNotFound => 
					statusCode = 404;
					response =  "File Not Found " + readFileReq.filename;
					println@Console( response )(),
				IOException =>
					statusCode = 500;
					response = "Internal Server Error";
					println@Console( response )() 
			);

			getCurrentDateValues@Time()(currentDate);

			with ( currentDate ){
				filename = 	"" + .year + .month + .day;

				currentDate = .month + "/" + .day + "/" + .year
			};

			listRequest.directory = NEWS_FOLDER;
			listRequest.regex = filename + "_\\d\\.xml";
			list@File( listRequest )( listResponse );
			filename += "_" + ( #listResponse.result + 1 );

			articleContent = "<article>\n" +
								"<text>\n" + article.text +"\n</text>\n" +
								"<author>\n" + article.author + "\n</author>\n" +
								"<date>\n" + currentDate + "\n</date>\n" +
							"</article>";

			with ( file ){
				.content = articleContent;
				.filename = NEWS_FOLDER + "/" + filename + ".xml"
			};

			writeFile@File( file )();
			statusCode = 200;
			response = "Article stored as: " + filename
		}
	}]{nullProcess}

	[ postForm()( response ){
		readFileReq.filename = "../news/submit_news.html";
		readFile@File( readFileReq )( response );
		statusCode = 200
	}]{ nullProcess }

	[ getNews( newsRequest )( response ){
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
			response = "<news>";
			for( i = 0, i < newsRange, i++ ){
				readFileReq.filename = NEWS_FOLDER + "/" + listResponse.result[ i ];
				readFile@File( readFileReq )( article );
				response += article
			};
			response += "</news>";
			statusCode = 200
		}
	}]{ nullProcess }
}
