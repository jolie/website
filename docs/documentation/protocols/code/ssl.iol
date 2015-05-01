type SSLConfiguration:void {
	.ssl?:void{

		/*
		* Defines the protocol used in encryption.
		*
		* Default: "TLSv1"
		* Supported values: all Java encryption protocols:
		* SSL, SSLv2, SSLv3, TLS, TLSv1, TLSv1.1, TLSv1.2
		*/
		.protocol?:string

		/*
		* Defines the format used for storing
		* keys
		*
		* Default: "JKS"
		* Supported values: all java keystore formats:
		* JKS, JCEKS, PKCS12
		*/
		.keyStoreFormat?:string
		
		/*
		* Defines the path of the file where keys are stored
		* 
		* Default: null
		*/
		.keyStore?:string
		
		/*
		* Defines the password of the keystore
		*
		* Default: null
		*/
		.keyStorePassword?:string
		
		/*
		* Defines the format used in the trustStore
		* 
		* Default: JKS 
		*/
		trustStoreFormat?:string

		/*
		* Defines the path of the trustStore file
		* 
		* Default: null
		*/
		.trustStore?:string
		
		/*
		* Defines the password of the trustStore
		* 
		* Default: none
		*/
		.trustStorePassword?:string
	}
}
