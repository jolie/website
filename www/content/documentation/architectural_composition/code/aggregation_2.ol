outputPort A {
	Location: "socket://someurlA.com:80/"
	Protocol: soap
	Interfaces: InterfaceA
}

outputPort B {
	Location: "socket://someurlB.com:80/"
	Protocol: xmlrpc
	Interfaces: InterfaceB
}

outputPort C {
	Interfaces: InterfaceC
}

embedded {
	Java: "example.serviceB" in B
}

inputPort M {
	Location: "socket://urlM.com:8000/"
	Protocol: sodep
	Aggregates: A, B, C
}