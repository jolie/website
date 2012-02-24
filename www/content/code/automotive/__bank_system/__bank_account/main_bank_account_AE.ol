include "console.iol"
include "database.iol"
include "./public/interfaces/BankAccountInterface.iol"
include "runtime.iol"
include "string_utils.iol"
include "../../config/config.iol"


execution{ concurrent }

//--- INPUT PORTS -------------------------------------------------------------------------

inputPort BankAccountService {
	Location: Location_BankAccountAE
	Interfaces: BankAccountInterface
	Protocol: sodep
}

inputPort BankAccountAdmin {
	Location: Location_BankAccountAdminAE
	Interfaces: BankAccountAdminInterface
	Protocol: sodep
}

//--- INIT-------------------------------------------------------------------------

init
{
      loadLibrary@Runtime( "file:./lib/derby.jar" )();
      scope( ConnectionScope ) {
	install( IOException => println@Console( ConnectionScope.IOException.stackTrace )() );
	install( ConnectionError => println@Console( ConnectionScope.ConnectionError.stackTrace )() );
	with( connectionInfo ) {
		.host = "";
		.driver = "derby_embedded";
		.port = 0;
		.database = "./database/data/bank_accountAE";
		.username = "";
		.password = ""
	};
	println@Console("BANK ACCOUNT: connecting with " + connectionInfo.database + "...")();
	connect@Database( connectionInfo )();
	println@Console("BANK ACCOUNT: connection with " + connectionInfo.database + " done.")()
  }
}

include "main_bank_account.ol"