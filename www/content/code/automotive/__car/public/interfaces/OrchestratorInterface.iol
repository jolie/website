type StartRequest: void {
  .location: any	// the location of the car service
}

interface OrchestratorInterface {
OneWay:
	start( StartRequest )
}

type SelectGarageRequest: void {
  .car_location: any
  .car_coord: string
}

type SelectGarageResponse: void {
  .name: string
  .location: string
  .garage_coord: string
  .amount: int
  .transactionId: string
  .reservationId: string
  .bankLocation: string
}

type SelectTruckRequest: void {
  .car_location: any
  .car_coord: string
}

type SelectTruckResponse: void {
  .name: string
  .location: string
  .amount: int
  .transactionId: string
  .reservationId: string
  .bankLocation: string
}

type SelectRentalRequest: void {
  .name: string
  .location: string
  .amount: int
  .transactionId: string
  .reservationId: string
  .bankLocation: string
}

type SelectRentalResponse: void {
  .name: string
  .location: string
}

interface InnerOrchestratorInterface {
RequestResponse:
	selectGarage( SelectGarageRequest )( SelectGarageResponse )
	  throws GarageNotFound,
	selectTruck( SelectTruckRequest )( SelectTruckResponse )
	  throws TruckNotFound,
	selectRental throws RentalNotFound
}