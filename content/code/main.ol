include "console.iol"
include "config.iol"
include "authenticatorInterface.iol"
include "secretaryInterface.iol"


interface TutorInterface {
RequestResponse:
	projectEvaluation
}

interface UniversityInterface {
RequestResponse:
	checkPositionAvailability,
	submitProjectRequest
}

outputPort Authenticator {
Location: Authenticator_location
Protocol: sodep
Interfaces: AuthenticationInterface
}

outputPort Secretary {
Location: Secretary_location
Protocol: sodep
Interfaces: SecretaryInterface
}

outputPort Tutor {
Protocol: sodep
Location: Location_Tutor
Interfaces: TutorInterface
}

outputPort University {
Protocol: sodep
Location: Location_University
Interfaces: UniversityInterface
}