include "exam_type.iol"

type ListOfExamsRequest: void {
  .username: string
}

type ListOfExamsResponse: void {
  .exams*: Exam
}


interface SecretaryInterface {
RequestResponse:
  listOfExams( ListOfExamsRequest )( ListOfExamsResponse )
}