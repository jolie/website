type GetUniversityLocationRequest: void {
  .university_name: string
}

type GetUniversityLocationResponse: void {
  .location: string
}

interface UniversityRegistryInterface {
RequestResponse:
  getUniversityLocation( GetUniversityLocationRequest )( GetUniversityLocationResponse )
}