include "console.iol"
include "config.iol"
include "authenticatorInterface.iol"
include "secretaryInterface.iol"
include "thesisWFInterface.iol"
include "universityInterface.iol"
include "projectEvaluationWFInterface.iol"
include "universityRegistryInterface.iol"
include "clientInterface.iol"


interface TutorInterface {
RequestResponse:
	projectEvaluation
}

outputPort Authenticator {
Location: Authenticator_location
Protocol: sodep
Interfaces: AuthenticatorInterface
}

outputPort Secretary {
Location: Secretary_location
Protocol: sodep
Interfaces: SecretaryInterface
}

outputPort ProjectEvaluationWF {
Protocol: sodep
Location: ProjectEvaluationWF_location
Interfaces: ProjectEvaluationWFInterface
}

outputPort UniversityRegistry {
Location: UniversityRegistry_location
Protocol: sodep
Interfaces: UniversityRegistryInterface
}

outputPort University {
Protocol: sodep
Interfaces: UniversityInterface
}

outputPort Client {
Protocol: sodep
Interfaces: ClientInterface
}

inputPort ThesisWF {
Location: ThesisWF_location
Protocol: sodep
Interfaces: ThesisWFTutorInterface, 
	    ThesisWFStudentInterface, 
	    ThesisWFUniversityInterface
}

init {
  println@Console("THESIS WF")()
}


main {
  startWF( request );
  println@Console("Received request from student:" + request.username )();
  university_name = request.university;
  starting_date = request.starting_date;
  ending_date = request.ending_date;
  thesis_title = request.thesis_title;
  thesis_abstract = request.thesis_abstract;
  username = request.username;
  Client.location = request.location;
  token_thesis_wf = new;
  {
    {
      //Tutor activity
      with( project_evaluation_req ) {
	.token_thesis_wf = token_thesis_wf;
	.username = username;
	.title = thesis_title;
	.abstract = thesis_abstract
      };
      projectEvaluation@ProjectEvaluationWF( project_evaluation_req );
      println@Console("Sent project evaluation to ProjectEvaluationWF")();
      evaluationFromTutor( thesis_evaluation );
      println@Console("Received evaluation from tutor")();
      linkIn( lnk_tutor );
      sendListOfExams@ProjectEvaluationWF( exam_list );
      println@Console("Sent list of exams to tutor director")();
      evaluationFromTutorDirector( exam_evaluation );
      println@Console("Received evaluation from tutor director")()
    }

    |

    {
      list_exams_req.username = username;
      listOfExams@Secretary( list_exams_req )( exam_list );
      println@Console("Received list of exams")();
      linkOut( lnk_university );
      linkOut( lnk_tutor )
    }

    |

    {
      //University activity
      unv_loc_req.university_name = university_name;
      getUniversityLocation@UniversityRegistry( unv_loc_req )( unv_loc_res );
      println@Console("Received location from university registry")();
      University.location = unv_loc_res.location;
      check_grant_req.starting_date = starting_date;
      check_grant_req.ending_date = ending_date;
      checkGrantAvailability@University( check_grant_req )( check_grant_res );

      linkIn( lnk_university );

      with( prj_submission_req ) {
	.thesis_abstract = thesis_abstract;
	.thesis_title = thesis_title;
	.exams -> exam_list
      };
      projectSubmission@University( prj_submission_req );
      projectEvaluationFromUniversity( unv_result );

      if ( check_grant_res.result == "y" ) {
	grant_req.starting_date = starting_date;
	grant_req.ending_date = ending_date;
	grant_req.exams -> exam_list;
	requestGrant@University( grant_req )( grant_res )
      }
    }
  }
  ;
  with( final_result ) {
    .thesis_evaluation = thesis_evaluation.result;
    .exam_evaluation = exam_evaluation.result;
    .university_evaluation = unv_result.result;
    .grant_evaluation = grant_res.result
  };
  finalResult@Client( final_result )
}