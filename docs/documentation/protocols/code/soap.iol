type SoapConfiguration:void {

	/* 
	* Defines the XML Schema files containing
	* the XML types to be used in SOAP messages
	*
	* Default: none
	*/
	.schema?:void {
		/* 
		* Defines the URL of an XML Schema file
		*
		* Default: none
		* Supported values: any valid XML Schema URL
		*/
		.schema_url[1, *]:string
	}	

	/* 
	* If true, converts XML node attributes to subnodes
	* in the relative Jolie tree under the "@Attributes"
	* node.
	*
	* Example:
	*   x.("@Attributes") = "hello"
	* would be converted to:
	*   <x myAttr="hello"/>
	* and vice versa.
	*
	* Default: false
	*/
	.convertAttributes?:bool

	/*
	* The URL of the WSDL definition associated to this SOAP protocol
	*
	* Default: none
	* Supported values: any valid URL referring a WSDL
	*/
	.wsdl?:string {
		/*
		* The port to refer to in the WSDL file for communicating
		* through this protocol.
		*
		* Default: none
		* Supported values: any port name in the WSDL file
		.port?:string
	}

	/* 
	* Use WS-Addressing
	*
	* Default: false
	*/
	.wsAddressing?:bool

	/* 
	* Defines the SOAP style to use for message encoding
	*
	* Default: "rpc"
	* Supported values: "rpc", "document"
	*/
	.style?:string {
		/*
		* Checked only if style is "document", it
		* defines whether the message is to be wrapped or not
		* in a node with the name of the operation.
		* 
		* Default: false
		*/
		.wrapped?:bool
	}

	/*
	* Defines additional attributes in the outgoing SOAP messages.
	*
	* Default: none
	*/
	.add_attribute?:void {
		/*
		* Defines an operation of the message
		* This parameter is considered only if .wrapped in .style
		* is true.
		*/
		.operation*:void {
			.operation_name:string
			.attribute:void {
				/*
				* Defines the prefix
				* of the name of the attribute
				*/
				.prefix?:string
				.name:string
				.value:string
			}
		}
		/*
		* Defines additional attributes of the
		* envelope
		*/
		.envelope?:void {
			.attribute*:void {
				.name:string
				.value:string
			}
		}
	}

	/*
	 * Defines whether the underlying connection should be kept open.
	 *
	 * Default: true
	 */
	.keepAlive?:bool

	/*
	* Defines whether debug messages shall be 
	* activated
	*
	* Default: false
	*/
	.debug?:bool

	/*
	* Defines whether the message request path
	* must be interpreted as a redirection resource or not.
	*
	* Default: false
	*/
	.interpretResource?:bool

	/*
	* The namespace name for outgoing messages.
	*
	* Default: void
	*/
	.namespace?:string
}
