/* Printer */

type JobID: void {
	.jobId: string
}

type PrintRequest:void {
	.content:string
}

type PrintResponse: JobID

interface PrinterInterface {
RequestResponse:
	print( PrintRequest )( PrintResponse ),
OneWay:
	del( JobID )
}

execution { concurrent }

inputPort PrinterInput {
Location: "socket://localhost:9000"
Protocol: sodep
Interfaces: PrinterInterface
}

main
{
	[ print( request )( response ) {
		jobId = new;
		println@Console( "Printing job id: " + jobId + ". Content: " + request.content )();
		response.jobId = jobId
	}]

	[ del( request ) ] {
		println@Console( "Deleting job id: " + request.jobId )()
	}
}

/* Fax */
type FaxRequest:void {
	.destination:string
	.content:string
}

interface FaxInterface {
OneWay:
	fax(FaxRequest)
}

execution { concurrent }

inputPort FaxInput {
Location: "socket://localhost:9001"
Protocol: sodep
Interfaces: FaxInterface
}

main
{
	fax( request );
	println@Console( "Faxing to " + request.destination + ". Content: " + request.content )()
}
