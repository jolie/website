include "projectEvaluationWFInterface.iol"
include "tutorInterface.iol"
include "tutorDirectorInterface.iol"
include "authenticatorInterface.iol"
include "thesisWFInterface.iol"
include "console.iol"
include "config.iol"

execution{ concurrent }

cset {
  token: SendListOfExamsRequest.token
	 EvaluatedProjectRequest.token
	 EvaluatedExamsRequest.token,
}

cset {
  token_thesis_wf: ProjectEvaluationRequest.token_thesis_wf
}

outputPort ThesisWF {
Location: ThesisWF_location
Protocol: sodep
Interfaces: ThesisWFTutorInterface
}

outputPort Authenticator {
Location: Authenticator_location
Protocol: sodep
Interfaces: AuthenticatorInterface
}

outputPort Tutor {
Protocol: sodep
Interfaces: TutorInterface, TutorDirectorInterface
}

inputPort ProjectEvaluationWF {
Location: ProjectEvaluationWF_location 
Protocol: sodep
Interfaces: ProjectEvaluationWFTutorInterface, ProjectEvaluationWFInterface
}

init {
  println@Console("PROJECT EVALUATION WF")()
}

main {
  projectEvaluation( request );
  csets.token = new;
  get_tutor_location_req.username = request.username;
  
  // retrieving tutor location
  getTutorLocation@Authenticator( get_tutor_location_req )( tutor_location );
  Tutor.location = tutor_location.location;
  println@Console("Retrieved Tutor location " + Tutor.location )();

  with( tutor_req ) {
    .token = csets.token;
    .username = request.username;
    .abstract = request.abstract;
    .title = request.title
  };
  putProjectEvaluation@Tutor( tutor_req );

  // waiting for evaluation from tutor
  evaluatedProject( eval_request );

  thesis_request.result = eval_request.result;
  thesis_request.token = csets.token_thesis_wf;
  evaluationFromTutor@ThesisWF( thesis_evaluation );

  sendListOfExams( exam_list );
   
  // retrieving tutor director location
  getTutorDirectorLocation@Authenticator( get_tutor_location_req )( Tutor.location );

  putListOfExams@Tutor( exam_list );

  evaluatedExams( eval_request );

  exam_request.result = eval_request.result;
  exam_request.token = cset.token_thesis_wf;
  evaluationFromTutorDirector@ThesisWF( exam_evaluation )
}