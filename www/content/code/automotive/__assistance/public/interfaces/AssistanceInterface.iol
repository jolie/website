type GetOrchestratorRequest: void {
  .fault: string
  .coord: string
  .car_model: string
}

type GetOrchestratorResponse: string

interface AssistanceInterface {
RequestResponse:
	getOrchestrator( GetOrchestratorRequest )( GetOrchestratorResponse )
}
