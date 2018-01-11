include "console.iol"

interface DynamicJavaServiceInterface {
  RequestResponse:
    start( void )( int )
}


execution{ concurrent }

outputPort DynamicJavaService {
  Interfaces: DynamicJavaServiceInterface
}

embedded {
  Java:
    "org.jolie.example.dynamicembedding.DynamicJavaService" in DynamicJavaService
}

inputPort MyInputPort {
  Location: "socket://localhost:9090"
  Protocol: sodep
  Interfaces: DynamicJavaServiceInterface
}


main {
    [ start( request )( response ) {
        start@DynamicJavaService()( response )
    }]
}
