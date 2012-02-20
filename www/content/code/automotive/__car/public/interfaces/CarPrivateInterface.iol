type GetGPSCoordinatesResponse: void {
  .coord: string
}

type GetDriverAndCarDataRequest: void {
  .name: string
  .surname: string
  .car_model: string
  .plate: string
}

type PayRequest: void {
  .payId: string
  .bankLocation: string
  .amount: int
}

type AbortTransactionRequest: void {
  .payId: string
  .bankLocation: string
  .amount: int
}

type SelectServiceRequest: void {
  .row*: void {
    .name: string
    .price: string
  }
}


type GetBankAccountResponse: void {
  .CCnumber: string
  .name: string
  .surname: string
}

type SetMessageRequest: void {
  .msg: string
}

interface CarPrivateInterface {
RequestResponse:
	/**!
	  returns the current GPS coordinates of the car
	*/
	getGPSCoordinates( void )( GetGPSCoordinatesResponse ),

	/**! 
	  returns the driver and the car data
	*/
	getDriverAndCarData( void )( GetDriverAndCarDataRequest ),

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
	selectService( SelectServiceRequest )( int ),

	/**!
	  it returns the bank account of the driver
	*/
	getBankAccount( void )( GetBankAccountResponse ),
OneWay:
	/**!
	  sets a message on the console
	*/
	setMessage( SetMessageRequest )
}