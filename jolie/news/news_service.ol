include "console.iol"
include "file.iol"
include "time.iol"
include "string_utils.iol"
include "xml_utils.iol"
include "news_service_interface.iol"

inputPort NewsService {
//  Location: "socket://localhost:8001/"
  Location: "local"
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

outputPort MarkedService{
	Interfaces: MarkedInterface
}

embedded{
	JavaScript:
		"../news/marked.js" in MarkedService
}

execution { concurrent }

constants {
	NEWS_FOLDER = "../news/news_storage",
	DELETED_FOLDER = "../news/news_trash"
}

init
{
	ACTION_PAGES.postNews = "../news/submit_news.html";
	ACTION_PAGES.editNews = "../news/edit_news.html";
	ACTION_PAGES.newsAdmin = "../news/admin_news.html";
	ACTION_PAGES.editArticle = "../news/edit_article.html"
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

			title = article.text;
			title.regex="(?m)^(?:#{1,6} |<h\\d>)([^<->]+)(?:|</h\\d>)$";
			find@StringUtils( title )( result );
			if( result ){
				title = result.group[1]
			} else {
				title = "untitled"
			};

			articleContent = "<article>\n" +
								"<title>" + title + "</title>\n" +
								"<text>" + article.text +"</text>\n" +
								"<author>" + article.author + "</author>\n" +
								"<date>" + currentDate + "</date>\n" +
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

	[ newsAdmin( request )( response ){
		scope (s){
			install( IOException FileNotFound => 
				println@Console( "Error on: " + readFileReq.filename )();
				statusCode = 500
			);

			if( request.action == "postNews"){
				readFileReq.filename = ACTION_PAGES.postNews;
				readFile@File( readFileReq )( response );
				statusCode = 200
			}
			else if( request.action == "editNews"){
				readFileReq.filename = ACTION_PAGES.editNews;
				readFile@File( readFileReq )( template );

				listRequest.directory = NEWS_FOLDER;
				listRequest.regex = "\\d+_\\d\\.xml";
				list@File( listRequest )( listResponse );
				newsTable = "<table><tr><th>Article</th><th>Author</th><th>Date</th><th>Actions</th></tr>";
				for( i = 0, i < #listResponse.result, i++ ){
					filename = listResponse.result[ i ];
					readFileReq.filename = NEWS_FOLDER + "/" + filename;
					readFile@File( readFileReq )( article );
					xmlToValue@XmlUtils( article )( article );
					length@StringUtils( article.text )( article.text.length );
					if( article.text.length > 0 ){
						with ( article ){
						if( .text.length > 100 ){
							.text.begin = 0;
							.text.end = 100;
							undef(.text.length);
							substring@StringUtils( .text )( .text );
							.text += "[...]"
						};
						newsTable += "<tr>" +
										"<td>" + .text + "</td>" +
										"<td>" + .author + "</td>" +
										"<td>" + .date + "</td>" +
										"<td>" + 
											"<a class='delete' onClick=\"deleteNews('" + filename + "')\">DEL</a>" +
											"<a class='edit' onClick=\"editNews('" + filename + "')\">EDIT</a>" +
										"</td>" +
									"</tr>"
						}
					}
				};

				newsTable += "</table>";

				template.replacement = newsTable;
				template.regex = "<!--newsTable-->";
				replaceAll@StringUtils( template )( response )
			}
			else if( request.action == "editArticle"){
				readFileReq.filename = ACTION_PAGES.editArticle;
				readFile@File( readFileReq )( response );
				statusCode = 200
			}
			else {
				readFileReq.filename = ACTION_PAGES.newsAdmin;
				readFile@File( readFileReq )( response );
				statusCode = 200
			}
		}
	}]{ nullProcess }

	[ editArticle ( editRequest )( response ){
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

			filename = editRequest.filename;

			articleContent = "<article>\n" +
								"<text>" + editRequest.text +"</text>\n" +
								"<author>" + editRequest.author + "</author>" +
								"<date>" + editRequest.date + "</date>\n" +
							"</article>";

			with ( file ){
				.content = articleContent;
				.filename = NEWS_FOLDER + "/" + filename
			};

			writeFile@File( file )();
			statusCode = 200;
			response = "Article " + filename + " modified successfully."
		}
	}]{ nullProcess }

	[ getSingleNews( singleNews )( response ){
		scope( s ){
			install( IOException FileNotFound => 
				println@Console( "Error on: " + filename )();
				statusCode = 500
			);

			readFileReq.filename = NEWS_FOLDER + "/" + singleNews.filename;
			readFile@File( readFileReq )( article );
			response = article;
			statusCode = 200
		}
	}]{ nullProcess }

	[ deleteNews( deleteArticle )( response ){
		scope (s){
			install( IOException FileNotFound => 
				println@Console( "Error on: " + filename )();
				response = "Error on: " + filename;
				statusCode = 500
			);
			filename = deleteArticle.filename;
			exists@File( NEWS_FOLDER + "/" + filename )(exists);
			if ( exists ){
				readFileReq.filename = NEWS_FOLDER + "/" + filename;
				readFile@File( readFileReq )( article );
				with ( file ){
					.content = article;
					.filename = DELETED_FOLDER + "/" + filename
				};
				writeFile@File( file )();
				delete@File( readFileReq.filename )( deleted );
				if ( deleted ){
					statusCode = 200;
					response = "Article " + filename + " moved to trash."
				}
				else{
					delete@File( file.filename )( ack );
					statusCode = 500;
					response = "Can't delete " + filename
				}
			}
		}
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
