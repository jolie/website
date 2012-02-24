include "bank_deploy.ol"
include "string_utils.iol"

execution{ concurrent } 

outputPort BankAccount {
  Location: Location_BankAccountVISA
  Protocol: sodep
  Interfaces: BankAccountInterface
}


inputPort BankService {
  Location: Location_BankVISA
  Protocol: sodep
  Interfaces: BankInterface
}
init
{
	println@Console("bankVISA Running...")()
}


include "main_bank.ol"