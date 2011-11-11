include "projectEvaluationWFInterface.iol"
include "tutorInterface.iol"
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
Interfaces: TutorInterface
}

inputPort ProjectEvaluationWF {
Location: ProjectEvaluationWF_location 
Protocol: sodep
Interfaces: ProjectEvaluationWFTutorInterface, ProjectEvaluationWFInterface
}

main {
  projectEvaluation( request );
  csets.token = new;
  get_tutor_location_req. username = request.username;
  
  // retrieving tutor location
  getTutorLocation@Authenticator( get_tutor_location_req )( Tutor.location );

  tutor_req << request;
  tutor_req.token = csets.token;
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