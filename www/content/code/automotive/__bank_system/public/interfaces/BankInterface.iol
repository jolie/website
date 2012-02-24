include "../../__bank_account/public/types/BankAccountTypes.iol"

type OpenTransactionRequest: void {
  .amount:int				// amount to be paid by someone
  .account: Account			// account to which the amount must be charged
  .location: string			// location to which notify the transaction commitment
  .correlation_data: undefined		// correlation data of the invoker
}

type OpenTransactionResponse: void {
  .transactionId: string
}

type CheckAvailabilityRequest: void {
  .account: Account
  .amount: int
}

type CloseTransactionRequest: void {
  .amount: int
  .transactionId: string
}

type CancelTransactionRequest: void {
  .transactionId: string
}

type PayTransactionRequest: void {
  .account: Account
  .amount: int
  .transactionId: string
  .bank_location: string
}

interface BankInterface {
RequestResponse:
	/**
	 * Opens a transaction, which will wait to be paid by someone.
	 * AuthFailed: if the ccData do not correspond
	 */
	openTransaction( OpenTransactionRequest )( OpenTransactionResponse )
	  throws AuthFailed InternalFault,
	
	/**
	* it pays an opened transaction
	*/
	closeTransaction( CloseTransactionRequest )( void )
	  throws WrongAmount,

	/**
	 * Pay an opened transaction
	 */
	payTransaction( PayTransactionRequest )( void )
	  throws CreditLimit 
		 WrongAmount,
	
	checkAvailability( CheckAvailabilityRequest )( void ) 
	  throws VerificationFailed,

	/**
	* cancel an opened transaction
	*/
	cancelTransaction( CancelTransactionRequest )( void )
}