include "tutorInterface.iol"
include "projectEvaluationWFInterface.iol"
include "console.iol"
include "config.iol"
include "string_utils.iol"

execution{ sequential }

outputPort ProjectEvaluationWF {
Location: ProjectEvaluationWF_location
Protocol: sodep
Interfaces: ProjectEvaluationWFTutorInterface
}

inputPort Tutor {
Location: MrBarnes_location
Protocol: sodep
Interfaces: TutorInterface
}

init {
  registerForInput@Console()();
  println@Console("MR BARNES")()
}

main {
  
  putProjectEvaluation( request );
  println@Console("Received project evaluation request from username " + request.username )();
  println@Console("Project title: " + request.title )();
  println@Console("Project abstract: " + request.abstract )();
  print@Console("Please, insert your evaluation with an int from 0 to 10 >>")();
  in( evaluation );
  evaluation_msg.token = request.token;
  evaluation_msg.result = int( evaluation );

  evaluatedProject@ProjectEvaluationWF( evaluation_msg )
}