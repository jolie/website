include "tutorInterface.iol"
include "tutorDirectorInterface.iol"
include "config.iol"
include "console.iol"

interface RedirectorInterface {
RequestResponse:
    shutdown
}

outputPort MrBarnes {
Location: MrBarnes_location
Protocol: sodep
Interfaces: TutorInterface
}

outputPort MrWho {
Location: MrWho_location
Protocol: sodep
Interfaces: TutorInterface, TutorDirectorInterface
}

inputPort Redirector {
Location: Tutor_location
Protocol: sodep
Interfaces: RedirectorInterface
Redirects: mrbarnes => MrBarnes,
	   mrwho => MrWho
}

init{
  println@Console("TUTOR REDIRECTOR")()
}

main {
  shutdown( request )( response ) {
    nullProcess
  }
}