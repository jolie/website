type StartRequest: void {
  .location: any	// the location of the car service
}

interface OrchestratorInterface {
OneWay:
	start( StartRequest )
}