//percentInterface.iol

type percent_request: void {
	.part: int
	.total: int
}

type percent_response: void {
	.percent_value: double
}

interface PercentInterface {
	RequestResponse: percent( percent_request )( percent_response )
}