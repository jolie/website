type EvaluationFromTutorRequest: void {
  .result:int
  .token: string
}

type EvaluationFromTutorDirectorRequest: void {
  .result:int
  .token: string
}

type StartWFRequest: void {
  .username: string
  .thesis_title: string
  .thesis_abstract: string
  .university: string
  .starting_date: string
  .ending_date: string
}

type ProjectEvaluationFromUniversityRequest: void {
  .result: string
  .token: string
}


interface ThesisWFTutorInterface {
OneWay:
  evaluationFromTutor( EvaluationFromTutorRequest ),
  evaluationFromTutorDirector( EvaluationFromTutorDirectorRequest )
}

interface ThesisWFStudentInterface {
OneWay:
  startWF( StartWFRequest )
}

interface ThesisWFUniversityInterface {
OneWay:
  projectEvaluationFromUniversity( ProjectEvaluationFromUniversityRequest )
}