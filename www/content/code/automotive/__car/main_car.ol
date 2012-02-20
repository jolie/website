include "./__console_manager/public/interfaces/ConsoleManagerInterface.iol"
include "../__assistance/public/interfaces/AssistanceInterface.iol"
include "./public/interfaces/CarInterface.iol"
include "./public/interfaces/CarPrivateInterface.iol"
include "../config/config.iol"
include "file.iol"
include "runtime.iol"
include "console.iol"
include "string_utils.iol"

execution{ concurrent }


interface BankInterface {
RequestResponse:
	openTransaction throws AuthFailed InternalFault,
	payTransaction throws CreditLimit WrongAmount InternalFault,
}


interface OrchestratorInterface {
OneWay:
	start
}

interface ConsoleManagerInterface {
RequestResponse:
	select
}

interface AutomotiveMainInterface {
OneWay:
	setMessage
}

//-------OUTPUT PORTS-----------------------------------------------
outputPort Orchestrator {
Location: "local"
Interfaces: OrchestratorInterface
}

outputPort AutomotiveMain {
Location:"local"
Interfaces: AutomotiveMainInterface
}

outputPort Assistance {
Protocol: sodep
Location: Location_Assistance
Interfaces: AssistanceInterface
}

outputPort Bank {
Protocol: sodep
Interfaces: BankInterface
}

outputPort ConsoleManager {
Interfaces: ConsoleManagerInterface
}

embedded {
	Jolie:
		"./__console_manager/main_console_manager.ol" in ConsoleManager
	Java:
		"com.italianasoftware.automotive.AutomotiveMainJS" in AutomotiveMain
}

inputPort CarOut {
Location: Location_Car
Protocol: sodep
Interfaces: CarInterface
}

inputPort CarInner {
Protocol: sodep { .debug = 1 }
Location: "local"
Interfaces: CarPrivateInterface, CarInterface
}

init
{
	global.coord = "44.14205871186485, 12.243232727050781";
	global.car_model = "Fast Car TGF76J";
	with( global.driver_and_car_data ) {
	  .name = "Homer";
	  .surname = "Simpson";
	  .car_model = global.car_model;
	  .plate = "XYZXYZ"
	};
	with ( global.account ) {
		.CCnumber="12345678";
		.name="Homer";
		.surname="Simpson"
	};
	Bank.location = Location_BankAE;
	getFileSeparator@File()( global.fileSeparator );
	getServiceDirectory@File()( global.serviceDirectory );
	println@Console("Running...")();
	install( BankFault => nullProcess )
}

main
{
	
	
	[ selectService( request )( response ){
		select@ConsoleManager( request )( selection );
		response -> request.row[ selection ]
	}] { nullProcess }
	
	
	[ getGPSCoordinates()( response ){
		response.coord = global.coord
	}] { nullProcess }
	
	[ getDriverAndCarData( )( response ){
	      response -> global.driver_and_car_data
	}] { nullProcess }
	
	[ setMessage( request )]{
		setMessage@AutomotiveMain( request )
	}
	
	[ pay( request )( ){
		scope( pay_bank ) {
			install( CreditLimit => //WrongAmount InternalFault =>
				setMessage@AutomotiveMain("! - Fault in payment");
				throw( BankFault )
			);
			bank_request -> request;
			bank_request.account -> global.account;			
			payTransaction@Bank( bank_request )()
		}
	}]{ nullProcess }
	
	[ abortTransaction( request )( response ){
		setMessage@AutomotiveMain("! - aborted transaction")
	}] { nullProcess }
	
	[ getBankAccount()( response ){
		response -> global.account
	}] { nullProcess }
	
	[ carFault( request )]{
		setMessage@AutomotiveMain( ". - Car fault raised:" + request.fault );
		fReq.directory = global.serviceDirectory;
		fReq.regex = "orchestrator.ol";
		list@File( fReq )( r );
		// delete the existing orchestrator.ol
		scope( deletingFile ){
			install( IOException => println@Console("Fault enconutered in deleting file")());
			if ( #r.result > 0 ) {
				delete@File(
					global.serviceDirectory + global.fileSeparator + "orchestrator.ol"
				)()
			}
		};
		// get the orchestrator depending on the fault and the gps coordinates
		req_orc << request;
		req_orc.coord -> global.coord;
		req_orc.car_model = global.car_model;
		
		getOrchestrator@Assistance( req_orc )( resp_orc );
		
		// create the new orchesrator.ol
		wf.filename = "orchestrator.ol";
		wf.content -> resp_orc;
		scope(t){
			install( IOException => println@Console(t.fault.stackTrace)());
			writeFile@File( wf )()
		};
		embedInfo.type = "Jolie";
		
		embedInfo.filepath = global.serviceDirectory + global.fileSeparator + "orchestrator.ol";
		loadEmbeddedService@Runtime( embedInfo )( Orchestrator.location );
		getLocalLocation@Runtime()( start_req.location );
		start@Orchestrator( start_req )
	}
	
}