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

inputPort TutorDirector {
Location: "local"
Protocol: sodep
Interfaces: TutorDirectorInterface
}

init {
  registerForInput@Console()()
}

main {

  putListOfExams( request );
  println@Console("Received list of exams evaluation request from username " + request.username )();
  valueToPrettyString@StringUtils( request )( s );
  println@Console("Exam list:" + s )();
  print@Console("Please, insert your evaluation with an int from 0 to 10 >>")();
  in( evaluation );
  evaluation_msg.token = request.token;
  evaluation_msg.result = int( evaluation );

  evaluatedExams@ProjectEvaluationWF( evaluation_msg )
}