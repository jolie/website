include "../types/BankAccountTypes.iol"

type AuthAccountRequest: Account

type CheckBankAccountAvailabilityRequest: void {
  .account: Account
  .amount: int
}

type AddAmountRequest: void {
  .account: Account
  .amount: int
}

type SubAmountRequest: void {
  .account: Account
  .amount: int
}


interface BankAccountInterface {
RequestResponse:
	/**
	 * Verifies the credentials of a given cc
	 * @response:void 	the credentials are verified
	 * @throws AuthFailed 	the credentials are not verified
	 */
	authAccount( AuthAccountRequest )( void ) 
	  throws AuthFailed,
	
	/**
	 * Verifies the amount availability of a given username
	 * @request:void {
	 * 	<< bankAccountType
	 * }
	 * @response:void 			the credentials are verified
	 * @throws VerificationFailed 	the credentials are not verified
	 */
	checkBankAccountAvailability( CheckBankAccountAvailabilityRequest )( void )
	  throws VerificationFailed,
	
	/**
	 * It adds an amount of money to the given cc number
	 */
	addAmount( AddAmountRequest )( void )
	  throws AuthFailed,
	
	/**
	 * It subtracts an amount of money to the given cc number
	 */
	subAmount( SubAmountRequest )( void ) 
	  throws AuthFailed
	
}

