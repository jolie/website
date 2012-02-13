include "secretaryInterface.iol"
include "config.iol"
include "console.iol"

execution{ concurrent }

inputPort Secretary {
Location: Secretary_location
Protocol: sodep
Interfaces: SecretaryInterface
}

init {
  println@Console("SECRETARY")()
}

main {
  listOfExams( request )( response ) {
    if ( request.username == "homer_simpsons" ) {
      with( response ) {
	with( .exams[0] ) {
	  .name = "physics";
	  .date = "1/1/2009";
	  .mark = 22
	};
	with( .exams[1] ) {
	  .name = "mathematics";
	  .date = "1/10/2009";
	  .mark = 27
	};
	with( .exams[2] ) {
	  .name = "computer science";
	  .date = "11/2/2010";
	  .mark = 29
	}
      }
    }
  }
}