include "console.iol"

include "FirstJavaServiceInterface.iol"

interface LocalInterface {
OneWay:
  reply( HelloWorldResponse )
}

outputPort FirstJavaServiceOutputPort {
  Interfaces: FirstJavaServiceInterface
}

embedded {
  Java:
    "org.jolie.example.FirstJavaService" in FirstJavaServiceOutputPort
}

inputPort MyLocalPort {
  Location: "local"
  Interfaces: LocalInterface
}


main {
    request.message = "Hello world!";
    request.sleep = 3000;
    AsyncHelloWorld@FirstJavaServiceOutputPort( request );
    reply( response );
    println@Console( response.reply )()
}
