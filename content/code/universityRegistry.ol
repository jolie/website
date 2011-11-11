include "universityRegistryInterface.iol"
include "config.iol"
include "console.iol"

execution{ concurrent }

inputPort UniversityRegistry {
Location: UniversityRegistry_location
Protocol: sodep
Interfaces: UniversityRegistryInterface
}

init {
  println@Console("UNIVERSITY REGISTRY")()
}

main {
  getUniversityLocation( request )( response ) {
    if( request.university_name == "University of Bologna" ) {
      response.location = UniversityOfBologna_location
    }
  }
}