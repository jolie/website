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
    install( WrongMessage => println@Console( main.WrongMessage.msg )() );

    request.message = "I am Obi";
    HelloWorld@FirstJavaServiceOutputPort( request )( response );
    println@Console( response.reply )()
}
