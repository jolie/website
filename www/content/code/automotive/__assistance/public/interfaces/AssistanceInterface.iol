type GetOrchestratorRequest: void {
  .fault: string
  .coord: string
  .car_model: string
}

type GetOrchestratorResponse: void {
  .code: string
}

type GetRequestsResponse: void {
  .request*: void {
      .fault: string
      .coord: string
      .car_model: string
      .image: string
  }
}

type GetDetailsRequest: void {
  .coord: string
}

type GetDetailsResponse: void {
  .fault: string
  .coord: string
  .car_model: string
  .image: string
  .name: string
  .surname: string
  .address: string
}

interface AssistanceInterface {
RequestResponse:
	getOrchestrator( GetOrchestratorRequest )( GetOrchestratorResponse )
}

interface AssistanceInterfaceEmbedded {
RequestResponse:
	getRequests( void )( GetRequestsResponse ),
	getDetails( GetDetailsRequest )( GetDetailsResponse )
}
