include "locations.iol"
include "console.iol"


/*
 * types{
 * creditCardType {
 *	.type: string			
 *	.number:string
 *	.expirationDate:string
 *	.name=string
 *	.secretCode:string
 *	}
 * }
 * bankAccountType {
 * 	<< creditCardType
 *	.amount:int  		the total amount available for a given account
 *}
*/

//--- INTERFACES -------------------------------------------------------------------------

interface TransactionInInterface {
RequestResponse:
	/**
	 * Opens a transaction, which will wait to be paid by someone.
	 * @request:void {
	 * 	.amount:int				amount to be paid by someone
	 *	.account << accountType	account to which the amount must be charged
	 *	.location:string			location to which notify the transaction commitment
	 * }
	 * @response: void {
	 * 	.transactionId:int			unique transaction identifier
	 * @throws AuthFailed			if the ccData do not correspond
	 * }
	 */
	openTransaction throws AuthFailed DBFault,
	
	/**
	 * Pay an opened transaction
	 * @request:void {
	 *     .ccData << accountType	user account 
	 *	.amount:int				amount to pay
	 *	.transactionId:int			unique transaction identifier
	 *	.bankLocation:string		location of the service bank to which 
	 * }
	* @response:void
	* @throw CreditLimit			fault raised if the payer credit is not sufficient for paying
	 */
	payTransaction throws CreditLimit,
	checkAvailability
}

interface TransactionOutInterface {
RequestResponse:
	
	/**
	* pays an opened transaction
	* @request:void{
	*	.amount:int				amount to pay
	*	.transactionId:int			unique transaction identifier	
	* }
	* @response:void
	*/
	closeTransaction,
	
	
	/**
	* cancel an opened transaction
	* @request:void{
	*	.transactionId:int			unique transaction identifier	
	* }
	* @response:void
	*/
	cancelTransaction
}


outputPort Bank {
	Location:	Location_BankAE
	Protocol:	sodep
	Interfaces: TransactionInInterface
}

main 
{
	with ( request.account ) {
		.name = "Claudio";
		.surname = "Guidi";
		.CCnumber = "12345678"
	};
	request.amount = -1500;
	checkAvailability@Bank( request )( response )
	
}