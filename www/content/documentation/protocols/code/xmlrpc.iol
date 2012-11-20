type SoapConfiguration:void {

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
	* Defines if connection shall be
	* kept alive or not
	*
	* Default: 0
	* Supported values: 1 or 0
	* 1 closes it, 0 (or any other) keeps it alive
	*/
	.keepAlive?: int

	/*
	* Defines if debug messages shall be 
	* activated
	*
	* Default: 0
	* Supported values: 0 or 1
	*/
	.debug?: int
}
