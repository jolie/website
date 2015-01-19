## Embedding a Java service

When embedding a Java service, the path URL must unambiguously identify a Java class, which must also be in the Java classpath of the Jolie interpreter. The class must extend the `JavaServices` abstract class, offered by the Jolie Java library for supporting the automatic conversion between Java values and their Jolie representations.

Each method of the embedded class is seen as an operation from the embedder, which will instantiate an object using the class and bind it to the output port. Embedding Java services is particularly useful for interacting with existing Java code or to perform some task where computational performance is important.

---

## The `println@MyConsole` example

Many services of the Jolie standard library (like `Console`) are Java services.

Each public method of the Java Service is an input operation invokable by the embedder. Depending on the output object, each method represents a one-way operation (if the output is void) or a request-response (for non-void outputs). This behaviour can be overridden by using the `@RequestResponse` annotation when declaring a void-returning operation.

Let us write our own `MyConsole` Java service that offers a `println` request-response operation. `println` is a public method of `MyConsole` class that takes a string as request and prints it at console.

<div class="code" src="embedding_java_1.java"></div>

Once stored in the `example` folder, as defined by the package statement, our Java class must be compiled into a .jar library and added to the folder "javaServices" in Jolie's installation directory:

- run the Java compiler on our MyConsole.java file adding the *jolie.jar* library in the classpaths (`-cp`): `javac -cp /path/to/jolie.jar MyConsole.java`;
- compress the MyConsole.class file into a .jar library with the `jar` command: `jar cvf example.jar example/MyConsole.class`
- move the example.jar file into javaServices folder in Jolie installation directory.

Once our service is visible by Jolie's interpreter, we can embed it in a Jolie service:

<div class="code" src="embedding_java_1.ol"></div>

The embedder construct, at Line 10, declares the type keyword as `Java` and defines the path name of the Java Service as `package_name.class_name`.

---

## Using a request-response operation in Java services

To practice on request-response operations between embedded and embedder, let us rewrite the *twice* service used in the section [Embedding a Jolie Service](architectural_composition/embedding_jolie.html).

We use the previously written Java Service `MyConsole` to print the result and show how to embed multiple classes.

<div class="code" src="embedding_java_2.java"></div>

Note that both input and output types of each method, although meant to be primitive types `int` and `double`, must be declared as their wrapping classes, respectively `Interger` and `Double`.

Following, the Jolie service embeds both MyConsole and Twice classes:

<div class="code" src="embedding_java_2.ol"></div>

---

## Handling structured messages and embedder's operations invocation

A Java Service can also call an operation of the embedder by means of the `sendMessage` method of Jolie standard library. In this example we use the `Value` and `ValueVector` objects to handle a custom-typed message from a request-response operation invoked on the embedder.

<div class="code" src="embedding_java_3.ol"></div>

The embedder acts as a bridge between two embedded Java Services, `MyJavaExample` which requests a `split` operation and, `Splitter` which implements it.

<div class="code" src="embedding_java_4.java"></div>

After `start()` is called by the embedder, our Java Service creates a `Value` object according to the `Split_req` type definition. At Line 20 it creates a request message, defining the invoked operation (`split`), the resource (`/`), and the message (`s_req`). Finally, at Line 21, it sends the request and waits for receiving a response.

After receiving the response, the service prints at console the subnodes of the response exploiting the `ValueVector` object.

The comprehensive code of this example can be downloaded here:

<div class="download"><a href="documentation/architectural_composition/code/embedding_java_code.zip">Embedding Java Code Example</a></div>