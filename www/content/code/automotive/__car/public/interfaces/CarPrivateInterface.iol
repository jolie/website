type GetGPSCoordinatesResponse: void {
  .coord: string
}

type PayRequest: void {
  .transactionId: string
  .bankLocation: string
  .amount: int
}

type AbortTransactionRequest: void {
  .transactionId: string
  .bankLocation: string
  .amount: int
}

type SelectServiceRequest: void {
  .row*: void {
    .name: string
    .price: int
    .coord: string
    .location: string
  }
  .msg: string
}

type SelectServiceResponse: void {
    .name: string
    .price: int
    .coord: string
    .location: string
}


type GetCarDataResponse: void {
  .CCnumber: string
  .name: string
  .surname: string
  .car_model: string
  .plate: string
  .bank_location: string
}

interface CarPrivateInterface {
RequestResponse:
	/**!
	  returns the current GPS coordinates of the car
	*/
	getGPSCoordinates( void )( GetGPSCoordinatesResponse ),

	/**!
	  performs a payment on a bank
	*/
	pay( PayRequest )( void ) 
	  throws BankFault,

	/**! 
	  abort a transaction on a bank
	*/	
	abortTransaction( AbortTransactionRequest )( void ),

	/**!
	  returns a service selection from the driver
	*/
	selectService( SelectServiceRequest )( SelectServiceResponse ),

	/**!
	  it returns the bank account of the driver
	*/
	getCarData( void )( GetCarDataResponse ),
OneWay:
	/**!
	  sets a message on the console
	*/
	setMessage( string )
}