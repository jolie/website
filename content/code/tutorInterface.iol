include "exam_type.iol"

type PutProjectEvaluationRequest: void {
  .username: string
  .title: string
  .abstract: string
  .token: string
}

interface TutorInterface {
OneWay:
  putProjectEvaluation( PutProjectEvaluationRequest )
}