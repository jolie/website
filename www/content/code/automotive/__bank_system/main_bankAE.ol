include "bank_deploy.ol"
include "./__banck_account/public/interfaces/BankAccountInterface.iol"

outputPort BankAccount {
	Location: "local"
	Interfaces: BankAccountInterface
}


embedded {
Jolie:
	"./__bank_Account/main_bank_account_AE.ol" in BankAccount
}

inputPort BankService {
	Location:	Location_BankAE
	Protocol:	sodep
	Interfaces: 	BankInterface, TransactionInterface
}

init
{
	println@Console("bankAE Running...")()
}

include "main_bank.ol"