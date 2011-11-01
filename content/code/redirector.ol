include "console.iol"
include "runtime.iol"

interface SubServiceInterface {
RequestResponse:
    operator
}

interface SumServiceInterface {
  RequestResponse:
    operator
}


outputPort SubService {
  Location: "socket://localhost:8001/"
  Protocol: sodep
  Interfaces: SubServiceInterface
}

outputPort SumService {
  Location: "socket://localhost:8002/"
  Protocol: sodep
  Interfaces: SumServiceInterface
}

inputPort MyService {
  Location: "socket://localhost:8000/"
  Protocol: sodep
  OneWay:
      shutdown
  Redirects:
              Sub => SubService,
              Sum => SumService
}

main
{	
	registerForInput@Console()();
	switch_status = 0;
	while ( 1 ) {
		println@Console("available commands: change, exit")();
		print@Console(">>")();
		in( command );
		if ( command == "change" ) {
			switch_request.inputPortName = "MyService";
			switch_request.outputPortName = "SubService";
			if ( switch_status == 0 ) {
			  switch_request.resourceName = "Sum"
			} else {
			  switch_request.resourceName = "Sub"
			};
			setRedirection@Runtime( switch_request )();
			switch_request.outputPortName = "SumService";
			if ( switch_status == 0 ) {
			  switch_request.resourceName = "Sub"
			} else {
			  switch_request.resourceName = "Sum"
			};
			setRedirection@Runtime( switch_request )();
			println@Console("Swithed Sum and Sub")();
			if ( switch_status == 0 ) {
			  switch_status = 1 
			} else {
			  switch_status = 0 
			}
		};
		if ( command == "exit" ) {
			exit
		}
	}
}