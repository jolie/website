include "authenticatorInterface.iol"
include "config.iol"
include "console.iol"

inputPort Authenticator {
Location: Authenticator_location
Protocol: sodep
Interfaces: AuthenticatorInterface
}

execution{ concurrent }

init {
  println@Console("AUTHENTICATOR")()
}

main {
  [ authenticate( request )( response ) {
    if( request.username != "homer_simpsons" || request.password != "springfield"  )  {
      throw( AuthenticationFailed )
    }
  }] { nullProcess }

  [ getTutorLocation( request )( response ) {
    if( request.username == "homer_simpsons" )  {
      response.location = Tutor_location + "/!/mrbarnes"
    };
    println@Console("Sent tutor location (" + response.location + ") for user " + request.username )()
  }] { nullProcess }

  [ getTutorDirectorLocation( request )( response ) {
    if( request.username != "homer_simpsons" )  {
      response.location = Tutor_location + "/!/mrwho"
    }
  }] { nullProcess }
}