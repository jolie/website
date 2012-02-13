include "exam_type.iol"

type CheckGrantAvailabilityRequest: void {
  .starting_date: string 
  .ending_date: string
}

type CheckGrantAvailabilityResponse: void {
  .result: bool
}

type RequestGrantRequest: void {
  .starting_date: void 
  .ending_date: void 
  .exams*: Exam
}

type RequestGrantResponse: void {
  .result: string
}

type ProjectSubmissionRequest: void {
  .title_thesis: string
  .abstract_thesis: string
  .exams*: Exam
  .token: string
  .requester_location: string
}

interface UniversityInterface {
RequestResponse:
  checkGrantAvailability( CheckGrantAvailabilityRequest )( CheckGrantAvailabilityResponse ),
  requestGrant( RequestGrantRequest )( RequestGrantResponse )
OneWay:
  projectSubmission( ProjectSubmissionRequest )
}