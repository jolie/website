include "exam_type.iol"

type ProjectEvaluationRequest: void {
  .username: string
  .title: string
  .abstract: string
  .token_thesis_wf: string
}

type SendListOfExamsRequest: void {
  .exams*: Exam
  .token: string
}

type EvaluatedProjectRequest: void {
  .token: string
  .result: int
}

type EvaluatedListRequest: void {
  .token: string
  .result: int
}

type EvaluatedExamsRequest: void {
  .token: string
  .result: int
}

interface ProjectEvaluationWFInterface {
OneWay:
	projectEvaluation( ProjectEvaluationRequest ),
	sendListOfExams( SendListOfExamsRequest )
}

interface ProjectEvaluationWFTutorInterface {
OneWay:
	evaluatedList( EvaluatedListRequest ),
	evaluatedProject( EvaluatedProjectRequest ),
	evaluatedExams( EvaluatedExamsRequest )
}