include "thesisWFInterface.iol"
include "console.iol"
include "string_utils.iol"
include "config.iol"
include "clientInterface.iol"

outputPort ThesisWF {
Location: ThesisWF_location
Protocol: sodep
Interfaces: ThesisWFStudentInterface
}

inputPort Client {
Location: Client_location
Protocol: sodep
Interfaces: ClientInterface
}

init {
  registerForInput@Console()();
  println@Console("CLIENT")()
}

main {
  println@Console("Please, insert your data.")();
  print@Console("Username:")();
  //in( request.username );
  request.username = "homer_simpsons";
  print@Console("Thesis title:")();
  //in( request.thesis_title );
  request.thesis_title = "my title";
  print@Console("Thesis abstract:")();
  //in( request.thesis_abstract );
  request.thesis_abstract = "my thesis abstract";
  print@Console("University:")();
  //in( request.university );
  request.university = "University of Bologna";
  print@Console("Starting date:")();
  //in( request.starting_date );
  request.starting_date = "1/1/2012";
  print@Console("Ending date:")();
  //in( request.ending_date );
  request.ending_date = "1/1/2013";
  request.location = Client_location;
  startWF@ThesisWF( request );
  
  finalResult( response );

  valueToPrettyString@StringUtils( response )( s );
  println@Console( s )()

}