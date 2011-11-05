type Exam: void {
  .name: string
  .date: string
  .mark: int
}

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