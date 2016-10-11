type JobID: void {
  .jobId: string
}

type FaxAndPrintRequest: void {
  .print: PrintRequest
  .fax: FaxRequest
}

type PrintRequest: void {
  .content: string
}

type PrintResponse: JobID

type FaxRequest: void{
  .destination: string
  .content: string
}

interface AggregatorSurface {
OneWay:
  del( JobID )
RequestResponse:
  faxAndPrint( FaxAndPrintRequest )( void ) throws Aborted( undefined ),
  print( PrintRequest )( PrintResponse ),
  fax( FaxRequest )( void )
}

outputPort Aggregator {
  Location: "socket://localhost:9002"
  Protocol: sodep
  Interfaces: AggregatorSurface
}