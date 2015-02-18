type BTL2CAPParameters:void {
	/*
	* Defines a "friendly" name that can be used to
	* identify the bluetooth service
	* 
	* Default: ""
	*/
	.name?: string

	/*
	* Defines whether a bluetooth device shall require 
	* authentication to provide a particular service.
	*
	* Default: true
	*/
	.authenticate?: bool

	/*
	* Defines whether to encrypt the communication 
	* among authenticated bluetooth devices.
	*
	* Default: false
	*/
	.encrypt?: bool

	/*
	* Defines whether to allow the communication with another
	* device only for the current time or to always allow
	* the communication for an authenticated particular device.
	*
	* Default: false
	*/
	.authorize?: bool

	/*
	* Defines whether the bluetooth service 
	* acts as a master 
	*
	* Default: false
	*/
	.master?: bool

	/*
	* Defines the reception maximum transmission unit (MTU)
	*
	* Default: 672 (bytes)
	* Supported values: {48, 65536}
	*/
	.receivemtu?: string

	/*
	* Defines the reception maximum transmission unit (MTU)
	*
	* Default: 672 (bytes)
	* Supported values: {48, 65536}
	*/
	.transmitmtu?: string
}
