outputPort ServiceA {
	Location: "socket://www.a_location.com/"
	Protocol: soap
	Interfaces: A_interface
}

outputPort ServiceB {
	Location: "socket://www.b_location.com/"
	Protocol: sodep
	Interfaces: B_interface
}

outputPort ServiceC {
	Location: "socket://www.b_location.com/"
	Protocol: http
	Interfaces: C_interface
}

inputPort MasterInput {
	Location: "socket://masterservice.com:8000/"
	Protocol: sodep
	Redirects:
		A => ServiceA,
		B => ServiceB,
		C => ServiceC
}