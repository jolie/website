include "console.iol"

include "FirstJavaServiceInterface.iol"

outputPort FirstJavaServiceOutputPort {
  Interfaces: FirstJavaServiceInterface
}

embedded {
  Java:
    "org.jolie.example.FirstJavaService" in FirstJavaServiceOutputPort
}


main {
    request.message = "Hello world!";
    HelloWorld@FirstJavaServiceOutputPort( request )( response );
    println@Console( response.reply )()
}
