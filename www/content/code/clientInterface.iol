type FinalResultRequest: void {
  .thesis_evaluation: int 
  .exam_evaluation: int
  .university_evaluation: string
  .grant_evaluation: string
}

interface ClientInterface {
OneWay:
  finalResult( FinalResultRequest )
}