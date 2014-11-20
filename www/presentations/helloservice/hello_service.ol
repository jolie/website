include "file.iol"

type HelloRequest: void {
    .name: string
}

type HelloResponse: void {
    .msg: string
}


interface HelloInterface {
RequestResponse:
      hello( HelloRequest )( HelloResponse ),
      default( undefined )( undefined )
}

execution{ concurrent }

inputPort HelloPort {
Location: "socket://localhost:8000"
Protocol: http {.format -> format; .default="default" }
Interfaces: HelloInterface
}

main {
      [ default( request )( response ) {
	    format = "html";
	    file.filename = request.operation;
	    readFile@File( file )( response )
      }] { nullProcess }
      
      [ hello( request )( response ) {
	    format = "json";
	    response.msg = "Hello " + request.name
      }] { nullProcess }
}

