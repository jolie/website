include "bank_deploy.ol"
include "./__banck_account/public/interfaces/BankAccountInterface.iol"

outputPort BankAccount {
	Location: "local"
	Interfaces: BankAccountInterface
}


embedded {
Jolie:
	"./__bank_Account/main_bank_account_VISA.ol" in BankAccount
}


inputPort BankService {
	Location:	Location_BankVISA
	Protocol:	sodep
	Interfaces: BankInterface, TransactionInterface
}
init
{
	println@Console("bankVISA Running...")()
}


include "main_bank.ol"