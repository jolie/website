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

type FaxRequest:void {
  .destination:string
  .content:string
}

interface FaxInterface {
RequestResponse:
  fax( FaxRequest )( void )
}

type FaxAndPrintRequest: void {
  .fax: FaxRequest
  .print: PrintRequest
}

interface AggregatorInterface {
  RequestResponse:
    faxAndPrint( FaxAndPrintRequest )( void ) throws Aborted
}

outputPort Printer {
  Location: "socket://localhost:9000"
  Protocol: sodep
  Interfaces: PrinterInterface
}

outputPort Fax {
  Location: "socket://localhost:9001"
  Protocol: sodep
  Interfaces: FaxInterface
}

inputPort Aggregator {
  Location: "socket://localhost:9002"
  Protocol: sodep
  Interfaces: AggregatorInterface
  Aggregates: Printer, Fax
}

// main { ... }