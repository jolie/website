type HttpConfiguration:void {
	/* General */

	/*
	 * Defines whether the underlying connection should be kept open.
	 * Remote webservers could have been configured to automatically close
	 * client connections after each request and without consideration of
	 * eventual "Connection: close" HTTP headers. If a Jolie client performs
	 * more than one request, the "keepAlive" parameter needs to be
	 * changed to "false", otherwise the client fails with:
	 * "jolie.net.ChannelClosingException: [http] Remote host closed connection."
	 *
	 * Default: true
	 */
	.keepAlive?:bool

	/*
	 * Defines the status code of the HTTP message.
	 * The parameter gets set on inbound requests and is read out on outbound requests.
	 * Attention: for inbound requests the assigned variable needs to be defined before
	 * issuing the first request, otherwise it does not get set (eg. statusCode = 0)
	 *
	 * eg.
	 * .statusCode -> statusCode
	 *
	 * Default: 200
	 * Supported Values: any HTTP status codes
	 */
	.statusCode?:string

	/*
	 * Defines whether debug messages shall be 
	 * activated
	 *
	 * Default: false
	 */
	.debug?:bool {
		/*
		 * Shows the message content
		 *
		 * Default: false
		 */
		.showContent?:bool
	}

	/*
	 * Defines whether the requests handled by the service
	 * are thread-safe or not.
	 * 
	 * Default: 
	 *	send 	-> true
	 *	receive -> false
	 */
	.concurrent?: bool

	/*
	 * Enable content compression in HTTP.
	 * On client side the "Accept-Encoding" header is set to "gzip, deflate"
	 * or according to "requestCompression". On the server the compression is
	 * enabled using gzip or deflate as the client requested it. gzip is
	 * preferred over deflate since it is more common.
	 * If the negotiation was successful, the server returns the compressed data
	 * with a "Content-Encoding" header and an updated "Content-Length" field.
	 *
	 * Default: true
	 */
	.compression?:bool

	/*
	 * Set the allowed mimetypes (content types) for compression.
	 * This flag operates server-side only and is unset per default, which means
	 * that common plain-text formats get compressed (among them text/html
	 * text/css text/plain text/xml text/x-js text/x-gwt-rpc application/json
	 * application/javascript application/x-www-form-urlencoded application/xhtml+xml
	 * application/xml).
	 * The delimitation character should be different to the mimetype names,
	 * valid choices include blank, comma or semicolon.
	 *
	 * "*" means compression for everything including binary formats, which is
	 * usually not the best choice. Many formats come pre-compressed, like
	 * archives, images or videos.
	 *
	 * Other webservers (Apache Tomcat, Apache HTTP mod_deflate) contain similar
	 * filter variables.
	 *
	 * Default: common plain-text formats
	 */
	.compressionTypes?:string

	/*
	 * Enables the HTTP request compression feature.
	 * HTTP 1.1 per RFC 2616 defines optional compression also on POST requests,
	 * which works unless HTTP errors are returned, for instance 415 Unsupported
	 * Media Type.
	 * Jolie allows to set the parameter to "gzip" or "deflate" which overrides
	 * also the "Accept-Encoding" header. This invites the server to use the same
	 * algorithm for the response compression.
	 * Invalid values are ignored, the compression mimetypes are enforced.
	 * If all conditions are met, the request content gets compressed, an
	 * additional "Content-Encoding" header added and the "Content-Length"
	 * header recalculated.
	 *
	 * Default: none/off
	 */
	.requestCompression?:string

	/* Outbound */

	/*
	 * Defines the HTTP response (outbound) message format.
	 * Supported values: xml, html, x-www-form-urlencoded, json,
	 * text/x-gwt-rpc, multipart/form-data, binary (data transfer in raw
	 * representation - no conversion), raw (data transfer in string representation
	 * with character set enforcement).
	 * It might be necessary to override the format with the correct content type,
	 * especially for "binary" and "raw" as shown below.
	 *
	 * Default: xml
	 */
	.format?:string

	/*
	 * Defines the content type of the HTTP message.
	 * These are the default content types for each kind of format, override if
	 * necessary:
	 * xml:                   text/xml
	 * html:                  text/html
	 * x-www-form-urlencoded: application/x-www-form-urlencoded
	 * json:                  application/json
	 * text/x-gwt-rpc:        text/x-gwt-rpc
	 * multipart/form-data:   multipart/form-data
	 * binary:                application/octet-stream
	 * raw:                   text/plain
	 *
	 * Default: none
	 */
	.contentType?:string

	/*
	 * Defines the HTTP response (outbound) message character encoding 
	 * Supported values: "US-ASCII", "ISO-8859-1", 
	 * "UTF-8", "UTF-16"... (all possible Java charsets)
	 *
	 * Default: "UTF-8"
	 */
	.charset?:string

	/*
	 * Set additional headers on HTTP requests
	 *
	 * Default: none
	 */
	.addHeader?:void {
		/*
		 * "header" contains the actual headers with their values
		 * ("value") as children.
		 *
		 * eg. for HTTP header "Authorization: TOP_SECRET":
		 * .addHeader.header[0] << "Authorization" { .value = "TOP_SECRET" }
		 *
		 * Default: none
		 */
		.header*:string {
			.value:string
		}
	}
	
	/*
	 * Defines the request method 
	 *
	 * Default: "POST"
	 * Supported values: "GET", "POST"
	 */
	.method?:string {
		/*
		 * "queryFormat" on a GET request may be set to "json" to have the
		 * parameters passed as JSON
		 *
		 * Default: none
		 */
		.queryFormat?:string
	}
	
	/*
	 * Defines a set of operation-specific aliases,
	 * multi-part headers, and parameters.
	 *
	 * Default: none
	 */
	.osc?:void {
		/*
		 * Jolie method name(s)
		 * eg. .osc.fetchBib.alias = "rec/bib2/%!{dblpKey}.bib" for method
		 *	 fetchBib()() which listens on "rec/bib2/%!{dblpKey}.bib"
		 * eg. .osc.default.alias = "" for method default()() which listens on "/"
		 *
		 * Default: none
		 */
		.operationName*:void {
			/*
			 * Defines a HTTP alias which represents 
			 * an alternative name to the location of
			 * "operationName"
			 *
			 * Default: none
			 * Supported values: URL address, string raw
			 */
			.alias*: string
			/*
			 * Defines the elements composing a multi-part 
			 * request for a specific operation.
			 *
			 * Default: none
			 */
			.multipartHeaders?:void {
				/*
				 * Defines the name of the part of 
				 * the multi-part request
				 * 
				 * Default: none
				 */
				.partName*:void {
					/*
					 * Defines the name of the file
					 * corresponding to a specific part
					 *
					 * Default: none
					 */
					.filename?:string
				}
			}
		}
	}

	/*
	 * HTTP request paths are usually composed by the medium's URI path
	 * as prefix and the resource name (or eventual aliases) as suffix.
	 * This works perfectly on IP sockets (medium "socket"), but is not
	 * desirable on other media like the UNIX domain sockets ("localsocket").
	 *
	 * Examples:
	 * - location: "socket://localhost:8000/x/", resource "sum" -> "/x/sum"
	 * - location: "localsocket://abs/s", resource "sum" -> "/ssum". "s"
	 *   is just the file name of the UNIX domain socket and has no meaning
	 *   in HTTP. With .dropURIPath = true the path component "s" is dropped
	 *   and the result becomes "/sum".
	 *
	 * Default: false
	 */
	.dropURIPath?:bool

	/*
	 * Defines the cache-control header of the HTTP message.
	 */
	.cacheControl?:void {
		/*
		 * Maximum age for which the resource should be cached (in seconds)
		 */
		.maxAge?:int
	}

	/*
	 * Defines the Content-Transfer-Encoding value of the HTTP message.
	 *
	 * Default: none
	 */
	.contentTransferEncoding?:string
	
	/*
	 * Defines the Content-Disposition value of the HTTP message.
	 *
	 * Default: none
	 */
	.contentDisposition?:string

	/* Inbound */

	/*
	 * Specifies the default HTTP handler method(s) on a server
	 * This is required for CRUD applications but also used in Leonardo which sets
	 * it to default()() (.default = "default").
	 *
	 * Default: none
	 */
	.default?:string {
		/*
		 * Handler for specific HTTP request methods, eg.
		 * .default.get = "get";
		 * .default.put = "put";
		 * .default.delete = "delete"
		 *
		 * Default: none
		 */
		.get?:string
		.post?:string
		.head?:string
		.put?:string
		.delete?:string
	}

	/*
	 * If set to "strict", applies a more strict JSON array to Jolie value
	 * mapping schema when the JSON format is used.
	 *
	 * Default: none
	 */
	.json_encoding?:string

	/*
	 * Defines the observed headers of a HTTP message.
	 *
	 * Default: none
	 */
	.headers?:void {
		/*
		 * <headerName> should be substituted with the actual header
		 * names ("_" to decode "-", eg. "content_type" for "content-type")
		 * and the value constitutes the request variable's attribute where
		 * the content will be assigned to.
		 * Important: these attributes have to be part of the service's
		 * input port interface, unless "undefined" is used.
		 *
		 * eg. in the deployment:
		 * .headers.server = "server"
		 * .headers.content_type = "contentType";
		 *
		 * in the behaviour, "req" is the inbound request variable:
		 * println@Console( "Server: " + req.server )();
		 * if ( req.contentType == "application/json" ) { ...
		 *
		 * Default: none
		 */
		.<headerName>*: string
	}

	/*
	* Defines the redirecting location subsequent to
	* a Redirection 3xx status code
	*
	* Default: none
	*/
	.redirect?:string

	/*
	* Defines a set of cookies used in the http communication
	*
	* Default: none
	*/
	.cookies?:void {
		/*
		* Defines a cookie named
		* "cookieName"
		* Default: none
		*/
		.cookieName*:void {
			/*
			* Defines the configuration of a cookie
			* 
			* Default: none
			*/
			.cookieConfig?:string{
				/*
				* Defines the domain of the cookie
				*
				* Default: ""
				*/
				.domain?:string
				/*
				* Defines the expiration time of the cookie
				*
				* Default: ""
				*/
				.expires?:string
				/*
				* Defines the "path" value of the cookie
				*
				* Default: ""
				*/
				.path?:string{}
				/*
				* Defines whether the cookie shall be encrypted 
				* and sent via HTTPS
				*
				* Default: 0
				*/
				.secure?:int{}
				/*
				* Defines the type of the cookie
				* 
				* Default: string
				*/
				.type?:string
			}
		}

	}
	
	/*
	 * Overrides the HTTP User-Agent header value on incoming HTTP messages
	 *
	 * eg.
	 * .userAgent -> userAgent
	 *
	 * Default: none
	 */
	.userAgent?:string

	/*
	 * Overrides the HTTP host header on incoming HTTP messages
	 *
	 * eg.
	 * .host -> host
	 *
	 * Default: none
	 */
	.host?:string
}
