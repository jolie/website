type EvaluationFromTutor: void {
  .result:int
  .token: string
}

interface ThesisWF {
OneWay:
  evaluationFromTutor( EvaluationFromTutor )
}