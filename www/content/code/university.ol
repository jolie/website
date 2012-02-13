include "universityInterface.iol"
include "thesisWFInterface.iol"
include "console.iol"
include "config.iol"

execution{ concurrent }

outputPort ThesisRequester {
Protocol: sodep
Interfaces: ThesisWFUniversityInterface
}

inputPort University {
Location: UniversityOfBologna_location
Protocol: sodep
Interfaces: UniversityInterface
}

init {
  registerForInput@Console()();
  println@Console("UNIVERSITY")()
}

main {
  [ checkGrantAvailability( request )( response ) {
    print@Console("Is grant available? (y/n) " )();
    in( answer );
    if ( answer == "y" ) {
      response.result = true
    } else {
      response.result = false
    }
  } ] { nullProcess }

  [ projectSubmission( request ) ] {
    // we suppose the request is accepted
    response.token = request.token;
    response.result = "y";
    ThesisRequester.location = request.requester_location;
    projectEvaluationFromUniversity@ThesisRequester( response )
  }

  [ requestGrant( request )( response ){
    // we suppose the grant is accepted
    response.result = "y"
  } ] { nullProcess }
}