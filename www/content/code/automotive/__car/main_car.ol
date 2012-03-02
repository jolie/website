include "./__console_manager/public/interfaces/ConsoleManagerInterface.iol"
include "./public/web_service_interfaces/AssistanceService.iol"
include "../__bank_system/public/interfaces/BankInterface.iol"
include "./public/interfaces/CarInterface.iol"
include "./public/interfaces/CarPrivateInterface.iol"
include "./public/interfaces/OrchestratorInterface.iol"
include "./__locator/public/interfaces/LocatorInterface.iol"
include "../config/config.iol"
include "file.iol"
include "runtime.iol"
include "console.iol"
include "string_utils.iol"

execution{ concurrent }

type SetMessageRequest: void {
  .msg: string
}

interface AutomotiveMainInterface {
OneWay:
	setMessage( SetMessageRequest )
}

//-------OUTPUT PORTS-----------------------------------------------
outputPort Locator {
Location: "local"
Interfaces: LocatorInterface
}

outputPort Orchestrator {
Location: "local"
Interfaces: OrchestratorInterface
}

outputPort AutomotiveMain {
Location:"local"
Interfaces: AutomotiveMainInterface
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
		"./__console_manager/main_console_manager.ol" in ConsoleManager,
		"./__locator/main_locator.ol" in Locator
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
Aggregates: Locator
}

init
{
	global.coord = "44.14205871186485, 12.243232727050781";
	global.car_model = "Fast Car TGF76J";
	with( global.car_data ) {
	  .name = "Homer";
	  .surname = "Simpson";
	  .car_model = global.car_model;
	  .plate = "XYZXYZ";
	  .CCnumber="12345678";
	  .bank_location = Location_BankAE
	};

	Bank.location = Location_BankAE;
	getFileSeparator@File()( global.fileSeparator );
	getServiceDirectory@File()( global.serviceDirectory );
	println@Console("Running...")();
	install( BankFault => nullProcess )
}

main {

	
	[ selectService( request )( response ){
		select@ConsoleManager( request )( selection );
		response -> request.row[ selection ]
	}] { nullProcess }

	
	[ getCarData( )( response ){
	      response -> global.car_data
	}] { nullProcess }
	
	[ setMessage( request )]{
		message.msg = request;
		setMessage@AutomotiveMain( message )
	}
	
	[ pay( request )( ){
		scope( pay_bank ) {
			install( CreditLimit => //WrongAmount InternalFault =>
				msg_car.msg = "! - Fault in payment";
				setMessage@AutomotiveMain( msg_car );
				throw( BankFault )
			);
    
			// performing a payment request
			with( bank_request ) {  
			  .transactionId = request.transactionId;
			  .bank_location = request.bankLocation;
			  .amount = request.amount;
			  with( .account ) {
			    .name = global.car_data.name;
			    .surname = global.car_data.surname;
			    .CCnumber = global.car_data.CCnumber
			  }
			};
			payTransaction@Bank( bank_request )()
		}
	}]{ nullProcess }
	
	[ abortTransaction( request )( response ){
		// bank aborting flow not implemented in this demo
		msg_car.msg = "! - aborted transaction";
		setMessage@AutomotiveMain( msg_car )
	}] { nullProcess }
	
	
	[ carFault( request )]{
		msg_car.msg = ". - Car fault raised:" + request.fault;
		setMessage@AutomotiveMain( msg_car );
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
		
		getOrchestrator@AssistanceServicePort( req_orc )( resp_orc );
		
		// create the new orchesrator.ol
		wf.filename = "orchestrator.ol";
		wf.content -> resp_orc.code;
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