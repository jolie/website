inputPort MyServiceSOAPPort {
	Location: "socket://localhost:8001"
	Protocol: soap {
		.wsdl = "./MyWsdlDocument.wsdl";
		.wsdl.port = "MyServiceSOAPPortServicePort"
	}
	Interfaces: MyServiceInterface
}