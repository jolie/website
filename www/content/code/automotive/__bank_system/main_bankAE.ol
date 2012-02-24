include "bank_deploy.ol"
include "string_utils.iol"

execution{ concurrent }

outputPort BankAccount {
  Location: Location_BankAccountAE
  Protocol: sodep
  Interfaces: BankAccountInterface
}


inputPort BankService {
  Location: Location_BankAE
  Protocol: sodep
  Interfaces: BankInterface
}

init
{
	println@Console("bankAE Running...")()
}

include "main_bank.ol"