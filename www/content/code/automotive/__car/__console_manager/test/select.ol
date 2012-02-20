include "../public/interfaces/ConsoleManagerInterface.iol"
include "string_utils.iol"
include "console.iol"


outputPort Test {
  Protocol: sodep
  Interfaces: ConsoleManagerInterface
  Location: "socket://localhost:8000"
}
	
main
{	
  request.msg = "test title";
  with( request ) {
    with( .row[ 0 ] ) {
      .name = "row0";
      .price = "0"
    };
    with( .row[ 1 ] ) {
      .name = "row1";
      .price = "1"
    };
    with( .row[ 2 ] ) {
      .name = "row2";
      .price = "2"
    }
  };
  select@Test( request )( response );
  valueToPrettyString@StringUtils( response )( s );
  println@Console( s )()
	
}