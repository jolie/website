include "bankLocations.iol"
include "console.iol"

/*
 * types{
 * accountType {
 *	.CCnumber:string
 *	.name:string
 *	.surname:string
 *	}
 * }
 *}
*/

execution { concurrent }
cset{ transactionId: request.transactionId }

//------------INRERFACES--------------------------------------------
interface BankAccountInterface {
RequestResponse:
	authAccount throws AuthFailed DBFault,
	checkAvailability throws VerificationFailed AuthFailed DBFault,
	addAmount throws AuthFailed DBFault,
	subAmount throws AuthFailed DBFault,
	connect throws DBFault
}

interface DatabaseInterface {
RequestResponse:
        connect,
        query,
        update
}

interface BankInterface {
RequestResponse:
	/**
	 * Opens a transaction, which will wait to be paid by someone.
	 * @request:void {
	 * 	.amount:int				amount to be paid by someone
	 *	.account << accountType		account to which the amount must be charged
	 *	.location:string			location to which notify the transaction commitment
	 *	.cset:undefined			correlation data of the invoker
	 * }
	 * @response: void {
	 * 	.transactionId:int			unique transaction identifier
	 * @throws AuthFailed			if the ccData do not correspond
	 * }
	 */
	openTransaction throws AuthFailed InternalFault,
	

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
	
	checkAvailability throws VerificationFailed
}

interface TransactionInterface {
RequestResponse:

	/**
	* pays an opened transaction
	* @request:void{
	*	.amount:int				amount to pay
	*	.transactionId:int			unique transaction identifier
	*	.counterPartBank:string		bank payer location
	*	.counterPartCCN:string		CCnumber payer
	* }
	* @response:void
	*/
	closeTransaction throws WrongAmount InternalFault,
	
	
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


//--------OUTPUTPORTS-------------------------------------------
outputPort BankAccount {
	Location: "local"
	Interfaces: BankAccountInterface
}

outputPort BankOut {
	Protocol: sodep
	Interfaces: TransactionInterface
}

outputPort Customer {
	Protocol: sodep
	OneWay:
		bankCommit
}

outputPort Database {
	Interfaces: DatabaseInterface
}

 //---------EMBEDDING-------------------------------------------
embedded {
Jolie:
	"bankAccount.ol" in BankAccount
}

embedded {
Java:
        "joliex.db.DatabaseService" in Database
}