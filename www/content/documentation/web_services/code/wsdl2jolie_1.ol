Retrieving document at 'http://www50.brinkster.com/vbfacileinpt/np.asmx?wsdl'.
type GetPrimeNumbersResponse:void {
	.GetPrimeNumbersResult?:string
}

type GetPrimeNumbers:void {
	.max:int
}

interface PrimeNumbersHttpPost {
RequestResponse:
	GetPrimeNumbers(string)(string)
}

interface PrimeNumbersHttpGet {
RequestResponse:
	GetPrimeNumbers(string)(string)
}

interface PrimeNumbersSoap {
RequestResponse:
	GetPrimeNumbers(GetPrimeNumbers)(GetPrimeNumbersResponse)
}

outputPort PrimeNumbersHttpPost {
	Location: "socket://www50.brinkster.com:80/vbfacileinpt/np.asmx"
	Protocol: http
	Interfaces: PrimeNumbersHttpPost
}

outputPort PrimeNumbersHttpGet {
	Location: "socket://www50.brinkster.com:80/vbfacileinpt/np.asmx"
	Protocol: http
	Interfaces: PrimeNumbersHttpGet
}

outputPort PrimeNumbersSoap {
	Location: "socket://www50.brinkster.com:80/vbfacileinpt/np.asmx"
	Protocol: soap {
			.wsdl = "http://www50.brinkster.com/vbfacileinpt/np.asmx?wsdl";
			.wsdl.port = "PrimeNumbersSoap"
	}
	Interfaces: PrimeNumbersSoap
}