include "sumInterface.ol"

inputPort SumInput {
	Location: "socket://localhost:8000/"
	Protocol: soap
	Interfaces: SumInterface
}