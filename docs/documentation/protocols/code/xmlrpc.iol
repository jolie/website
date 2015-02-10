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
}
