include "tutorInterface.iol"
include "tutorDirectorInterface.iol"
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

outputPort TutorDirector {
Interfaces: TutorDirectorInterface
}

embedded {
  Jolie:
    "tutor_director.ol" in TutorDirector
}

inputPort Tutor {
Location: MrWho_location
Protocol: sodep
Interfaces: TutorInterface
Aggregates: TutorDirector
}

init {
  registerForInput@Console()();
  println@Console("MR WHO")()
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