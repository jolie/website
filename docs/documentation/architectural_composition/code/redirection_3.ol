include "SumInterface.iol"
include "SubInterface.iol"

outputPort SubService {
  Location: Location_Sub
  Protocol: sodep
}

outputPort SumService {
  Location: Location_Sum
  Protocol: sodep
}

inputPort Redirector {
  Location: "socket://localhost:2002/"
  Protocol: sodep
  /* here we define the redirection mapping names of resources 
  (resp. Sub and Sum) to existing outputPorts 
  (resp. SumService and SubService) */
  Redirects:
  	Sub => SubService,
  	Sum => SumService
}

// main{ ... }