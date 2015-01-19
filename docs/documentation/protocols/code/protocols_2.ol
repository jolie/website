inputPort HTTPInput {
	Protocol: http {
		.keepAlive = 0; // Do not keep connections open
		.debug = DebugHttp; 
		.debug.showContent = DebugHttpContent;
		.format -> format;
		.contentType -> mime;
		.statusCode -> statusCode;
		.redirect -> location;
		.default = "default"
	}
	//Location: ...
	//Interfaces: ...
}