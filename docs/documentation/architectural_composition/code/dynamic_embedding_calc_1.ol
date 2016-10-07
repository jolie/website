type RequestType: void {
  .x: double
  .y: double
}

interface OperationInterface {
  RequestResponse:
    run( RequestType )( double )
}
