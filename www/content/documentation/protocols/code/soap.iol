type SoapConfiguration:void {

	// Defines the XML Schema files containing
	// the SOAP message XML vocabulary
	//
	// Default: none
	// Supported values: any valid .schema value
	.schema?: void {
		// Defines the URL of a XML Schema file
		//
		// Default: none
		// Supported values: any valid XML Schema URL
		.schema_url[1, *]: string
	}	

	// Defines if Jolie's values and 
	// SOAP's XMLNodes shall be converted from
	// a specific type to another
	//
	// Default: false
	// Supported values: true or false
	.convertAttributes?: bool

	// Defines the url of the SOAP's
	// WSDL definition 
	//
	// Default: none
	// Supported values: any valid URL referring a WSDL
	.wsdl?: string {
		// Defines the port in WSDL
		//
		// Default: none
		// Supported values: any valid port definition
		.port?: string
	}

	// Defines if the SOAP message includes
	// routing data as WS-Addressing
	//
	// Default: false
	// Supported values: true or false
	.wsAddressing?: bool

	// Defines the binding style
	// of a WSDL
	//
	// Default: RPC
	// Supported values: RPC or document
	.style?: string {
		// Checked only if style = "document", it
		// defines if the message is wrapped or not
		// 
		// Default: 1
		// Supported values: 0 or 1
		.wrapped?: int
	}

	// Defines additional attributes of the message.
	// .operation is evaluated only if .wrapped in .style
	// is set to default value or 1
	//
	// Default: none
	// Supported values: any add_attribute type 
	.add_attribute?: void {
		// Defines an operation of the message
		.operation*: void {
			.operation_name: string
			.attribute: void {
				// Defines the prefix
				// of the name of the attribute
				.prefix?: string
				.name: string
				.value: string
			}
		}
		// Defines additional attributes of the
		// envelope
		.envelope?: void {
			.attribute*: void {
				.name: string
				.value: string
			}
		}
	}

	// Defines if connection shall be
	// kept alive or not
	//
	// Default: 1
	// Supported values: 1 or 0
	.keepAlive?: int


	// Defines if debug messages shall be 
	// activated
	//
	// Default: 0
	// Supported values: 0 or 1
	.debug?: int

	// Defines if the message request path
	// must be interpreted or not
	// ("/" if not and message.RequestPath otherwise)
	//
	// Default: false
	// Supported values: true or false
	.interpretResource?: bool

	// The namespace containing the
	// SOAP actions
	//
	// Default: void
	// Supported values: any
	.namespace?:string
}
