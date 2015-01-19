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