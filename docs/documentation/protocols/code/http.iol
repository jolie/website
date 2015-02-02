type HttpConfiguration:void {

	/*
	* Defines a set of "headersNames" corresponding to
	* the values received in the header of a request.
	*
	* Default: none
	*/
	.headers?:void {
		/*
		* Defines the name of a header an references
		* its value
		*
		* Default: none
		*/
		.headerName*: string
	}

	/*
	* Defines the status code of the HTTP message.
	*
	* Default: 200
	* Supported Values: any HTTP status codes
	*/
	.statusCode?:string

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
	* Defines the content type of the HTTP message.
	*
	* Default: none
	*/
	.contentType?:string

	/*
	* Defines the content type of the HTTP message.
	*
	* Default: none
	*/		
	.charset?:string

	/*
	* Enable content compression in HTTP.
	* On client side the "Accept-Encoding: gzip, deflate" header is set and on the
	* server the compression is enabled using gzip or deflate as the client
	* requested it. gzip is preferred over deflate since it is more common.
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
	* text/css text/plain text/xml text/x-js application/json
	* application/javascript). The delimitation character should be different to
	* the mimetype names, valid choices include blank, comma or semicolon.
	*
	* "*" means compression for everything including binary formats, which is
	* usually not the best choice. Many formats come pre-compressed, like
	* archives, images or videos.
	*
	* Other webservers (Apache Tomcat, Apache HTTP mod_deflate) contain similar
	* filter variables.
	*
	* Default: none
	*/
	.compressionTypes?:string

	/*
	* Defines the format of the HTTP message.
	*
	* Default: none
	*/
	.format?:string
	
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

	/*
	* Defines the redirecting location subsequent to
	* a Redirection 3xx status code
	*
	* Default: none
	*/
	.redirection?:string

	/*
	 * Defines the character set to use for (de-)coding strings.
	 *
	 * Default: "UTF-8"
	 * Supported values: "US-ASCII", "ISO-8859-1", 
	 * "UTF-8", ... (all possible Java charsets)
	 */
	.charset?:string

	/*
	 * Defines whether the underlying connection should be kept open.
	 *
	 * Default: true
	 */
	.keepAlive?:bool

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
	* Defines whether debug messages shall be 
	* activated
	*
	* Default: false
	*/
	.debug?:bool

	/*
	* Defines a set of operation-specific aliases,
	* multi-part headers, and parameters.
	*
	* Default: none
	*/
	.osc?:void {
		.operationName*:void {
			/*
			* Defines the name of a parameter specific to 
			* "operationName"
			*
			* Default: none
			*/
			.parameterName?: void
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
			.multiparHeaders?:void {
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
	* Defines the request method used by a port
	*
	* Default: "POST"
	* Supported values: "GET", "POST"
	*/
	.method?:string

	/*
	* Set to the User-Agent header value 
	* after receiving a request
	*
	* Default: none
	*/
	.userAgent?:string
