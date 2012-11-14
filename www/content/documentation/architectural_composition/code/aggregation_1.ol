outputPort MyOP {
	Location: "socket://someurl.ex:80"
	Protocol: soap
	Interfaces: MyInterface
}

inputPort MyInput {
	Location: "socket://localhost:8000"
	Protocol: sodep
	Aggregates: MyOP
}