

type StartWFRequest: void {
  .username: string
  .thesis_title: string
  .thesis_abstract: string
  .university: string
  .starting_date: string
  .ending_date: string
  .location: string
}

type ProjectEvaluationFromUniversityRequest: void {
  .result: string
  .token: string
}


interface ThesisWFStudentInterface {
OneWay:
  startWF( StartWFRequest )
}

interface ThesisWFUniversityInterface {
OneWay:
  projectEvaluationFromUniversity( ProjectEvaluationFromUniversityRequest )
}