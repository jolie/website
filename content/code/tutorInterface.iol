include "exam_type.iol"

type PutProjectEvaluationRequest: void {
  .username: string
  .title: string
  .abstract: string
  .token: string
}

type PutListOfExamsRequest: void {
  .username: string
  .exams*: Exam
  .token: string
}

interface TutorInterface {
OneWay:
  putProjectEvaluation( PutProjectEvaluationRequest ),
  putListOfExams( PutListOfExamsRequest )
}