include "exam_type.iol"

type PutListOfExamsRequest: void {
  .username: string
  .exams*: Exam
  .token: string
}

interface TutorDirectorInterface {
OneWay:
  putListOfExams( PutListOfExamsRequest )
}