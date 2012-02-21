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
	 * @request:void {
	 *        .account << accountType	user account 
	 *	.amount:int			amount to pay
	 *	.transactionId:int		unique transaction identifier
	 *	.bankLocation:string		location of the service bank to which 
	 * }
	* @response:void
	* @throw CreditLimit WrongAmount InternalFault  fault raised if the payer credit is not sufficient for paying
	 */
	payTransaction throws CreditLimit WrongAmount InternalFault,
	
	checkAvailability( CheckAvailabilityRequest )( void ) 
	  throws VerificationFailed
}

interface BankTransactionInterface {
RequestResponse:

	
	
	
	/**
	* cancel an opened transaction
	* @request:void{
	*	.transactionId:int			unique transaction identifier	
	* }
	* @response:void
	*/
	cancelTransaction,
	
	/**
	* abort a performed transaction
	* @request:void{
	*	.transactionId:int			unique transaction identifier	
	* }
	* @response:void
	*/
	abortTransaction
}