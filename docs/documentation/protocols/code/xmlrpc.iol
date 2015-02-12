type XmlRpcConfiguration:void {

	/*
	* Defines the aliases for operation names.
	* Jolie does not support operation names with dots (e.g., myOp.operation),
	* aliases are expressed as protocol parameters as
	* aliases.opName = "aliasName"
	* 
	*
	* Default: none
	* Supported values: any valid operation alias definition
	*/
	.aliases: void {
		.operationName[ 1, * ]: void {
			.operationName: string
		}
	}

	/*
	 * Defines whether the underlying connection should be kept open.
	 *
	 * Default: false
	 */
	.keepAlive?: bool

	/*
	 * Defines whether debug messages should be activated
	 *
	 * Default: false
	 */
	.debug?: bool

	/*
	 * Enable the HTTP content compression
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
	 * Enables the HTTP request compression feature.
	 * HTTP 1.1 per RFC 2616 defines optional compression also on POST requests,
	 * which works unless HTTP errors are returned, for instance 415 Unsupported
	 * Media Type.
	 * Jolie allows to set the parameter to "gzip" or "deflate" which overrides
	 * also the "Accept-Encoding" header. This invites the server to use the same
	 * algorithm for the response compression. Invalid values are ignored.
	 * If all conditions are met, the request content gets compressed, an
	 * additional "Content-Encoding" header added and the "Content-Length"
	 * header recalculated.
	 *
	 * Default: none/off
	 */
	.requestCompression?:string
}
