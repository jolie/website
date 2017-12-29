## JavaServices

This tutorial explains how to develop JavaService classes which can be easily embedded into a Jolie service. For the sake of clarity, here we consider to use [Netbeans IDE](http://www.netbeans.org) as a project management tool, but the following instructions can be easily adapted to any kind of Java IDE.

The tutorial also presents some features of Java integration in Jolie, i.e., manipulating Jolie values in Java, calling operations from a Java service, and the dynamic embedding of JavaServices.

### Creation of a JavaService project
- If you are using Maven, just click on "New Project" icon and then select **Maven** -> **Java Application** as reported in the following picture.

<div class="doc_image">
	<img style="width:500px;" src="documentation/architectural_composition/img/createproject.png" />
</div>

- If you are creating a new project from scratch click on "New Project" icon and then select **Java** -> **Java Class Library**

<div class="doc_image">
	<img style="width:500px;" src="documentation/architectural_composition/img/createproject_java.png" />
</div>


Then, follows the instructions and give a name to the project (ex: `FirstJavaService`) and define the working directory.


### Dependencies
Before continuing with the development of a JavaService keep in mind that there is a dependency you need to add to your project in order to properly compile the JavaService code: the jar `jolie.jar` which comes with your jolie installation. Follow these instructions in order to prepare the file in order to be imported into your project:

- Locate the jolie.jar file into your system: jolie is usually installed into `/usr/lib/jolie` folder for linux like operative systems and in `C:\\Jolie` for Windows operative systems. In the installation folder of Jolie you can find the file jolie.jar. If you are not able to locate the jolie.jar file or you require some other jolie versions, [here](https://github.com/jolie/website/tree/master/www/files/releases) you can find the complete list of all the available releases of Jolie. Download the release you need.

- If you use Maven you could register the dependency in your local repo by using the following command
`mvn install:install-file -Dfile=<path-to-jolie.jar>/jolie.jar -DgroupId=jolie -DartifactId=jolie -Dversion=<version> -Dpackaging=jar`
**NOTE** we are going to register the dependency jolie.jar into [Maven Central](https://search.maven.org), when done such a step can be skipped.


### Importing the Jolie dependency into your JavaService project
If you use Maven it is very easy to import the Jolie dependency into your project, just add the following dependency into your pom.xml file:
<div class="code" src="maven_jolie_dependency.txt"></div>

If you manually manage your project just add the jolie.jar as an external dependency. In Netbeans you have to:

- Expand your project
- Right mouse button on *Libraries*
- Select *Add JAR/Folder*
- Select the jolie.jar file from the path selector

<div class="doc_image">
	<img style="width:200px;" src="documentation/architectural_composition/img/addjar.png" />
</div>

### The first JavaService
As a first example of a JavaService we present a sample scenario where we suppose to extend the features of a Jolie service by exploiting native Java computation. The architecture of the final system will look as it is represented in the following picture:

<div class="doc_image">
	<img style="width:500px;" src="documentation/architectural_composition/img/firstArchitecture.png" />
</div>
As it is possible to note, here the Jolie service communicate with the JavaService with a synchronous call equivalent to a RequestResponse.

Before writing the actual code of the JavaService it is important to create the
package which will contain it. Let us name it `org.jolie.example`. Then, let us create the new java file called `FirstJavaService.java`.

<div class="doc_image">
	<img style="width:200px;" src="documentation/architectural_composition/img/package.png" />
</div>


#### Writing the JavaService code
Here we present the code of our first JavaService which simply print out on the console a message received from an invoker and then reply with the message `I am your father`.

<div class="code" src="FirstJavaService.java"></div>

In the code there are some important aspects to be considered:

- We need to import two classes from the jolie dependency: `jolie.runtime.JavaService` and `jolie.runtime.Value`
- the class `FirstJavaService` must be extended as a JavaService: `... extends JavaService`
- the request parameter and the response one are objects `Value`
- it is possible to navigate the tree of a `Value` by using specific methods like `getFirstChild` (see below)
- the request message has a subnode `message` which contains a string
- the response message will contain the reply message in the subnode `reply`
- the core logic of the JavaService is just the line `System.out.println("message")` which prints out the content of the variable message on the console

#### Building the JavaService
Now we can build the JavaService, in particular we need to create a resulting `jar` file to be imported into the corresponding Jolie project. In order to do this, just click with the mouse right button on the project and select **Clean and Build**.

If you are managing the project with Maven you will find the resulting jar in folder *target*, whereas if you are manually managing the project you can find it in the folder *dist*.


#### Executing the JavaService
Now we are ready for embedding the JavaService into a Jolie service. It is very simple, just follows these steps:

- Create a folder where placing your jolie files, ex: `JolieJavaServiceExample`
- Create a subfolder named `lib` (`JolieJavaServiceExample/lib`)
- Copy the jar file of your JavaService into the folder `lib` (jolie automatically import all the libraries contained in the subfolder `lib`)
- Create a jolie interface file where defining all the available operations of your JavaService and name it `FirstJavaServiceInterface.iol`. It is worth noting that all the public methods defined in the class FirstJavaService can be promoted as operations at the level of a Jolie service. In our example the interface is called `FirstJavaServiceInterface` and it declares one operation called `HelloWorld` (the name of the operation must be the same name of the corresponding operation in the JavaService). The request and response message types define two messages where the former has a subnode named `message` and the latter is named `reply`.
<div class="code" src="FirstJavaServiceInterface.iol"></div>
- In the code of your jolie service, create an outputPort for your JavaService specifically addressed for operating with it. You can name the outputPort as you prefer (there are no restrictions), in this example we use the name `FirstJavaService`. Remember to join the JavaService interface in the outputPort declaration as we did in this example:
<div class="code" src="FirstJavaServiceOutputPort.ol"></div>
- Embed the JavaService by joining it with its ourputPort
<div class="code" src="FirstJavaServiceEmbedding.ol"></div>
- Complete your jolie code.

Here we report a complete example of a jolie code which calls the JavaService and prints out its response on the console. Save it in a file named `main.ol`. Note that the embedded construct takes as a type the keyword Java instead of Jolie because we are embedding a JavaService. As parameter the embedded construct takes the absolute class name obtained as *`package/name+class/name`*.
<div class="code" src="FirstJavaServiceExample.ol"></div>
At this point your jolie working directory should look like the following one:

- *your jolie working directory*
	- **lib**
		- FirstJavaService.jar
	- FirstJavaServiceInterface.iol
	- main.ol

You can run the jolie script by using the simple command `jolie main.ol`.

**NOTE** In order to avoid the creation of folder *lib*, it is possible to link the dependency *FirstJavaService.jar* in the command line as it follows:  `jolie -l <path-to-dependency>/FirstJavaService.jar main.ol`. In this way you are free to place the dependency where it is more suitable for you.

## Using the JavaService into a Jolie service
In the previous example we just wrote a Jolie script which exploits the JavaService *FirstJavaService*. Clearly, it is possible to exploit the same JavaService within a Jolie service by adding an inputPort to the previous script.
<div class="doc_image">
	<img style="width:500px;" src="documentation/architectural_composition/img/firstArchitectureService.png" />
</div>
In the following case we present a possible solution where the operation of the JavaService is exported to the inputPort by exploiting the same interface `FirstJavaServiceInterface` with a new implementation of the operation `HelloWorld` in the main scope of the service.
<div class="code" src="FirstJavaServiceExampleService.ol"></div>

Such a scenario is useful when we need to add some extra computation within the behaviour before invoking the JavaService (in the example we print out the request message before forwarding it to the JavaService). In those cases where there is no need to manipulate the messages in the behaviour, we could directly aggregate the JavaService outputPort in the inputPort of the service by obtaining a direct connection between the Jolie inputPort and the JavaService.
<div class="code" src="FirstJavaServiceExampleAggregation.ol"></div>

## Manipulating Jolie values in Java
In this section we deepen the usage of the class `Value` which allows for the management of Jolie value trees within Java.

#### Creating a value.
First of all, we need to create a Value in Java as we would do in Jolie. The following Java code creates a Value named `v`.
<div class="code" src="CreateValue.java"></div>

#### Getting the vector elements.
In each Jolie tree, a node is a vector. In order to access/get the vector elements of a node, you can use the method `getChildren( String subnodeName )` which returns the corresponding `ValueVector` of the subnode `subnondeName`. In the following example we get all the vector
elements of the subnode `subnode1`.
<div class="code" src="ValueVector.java"></div>

All the items of a ValueVector are Value objects. In order to access the Value element at index *i* it is possible to use the method `get( int index )`. In the following example we access the third element of the subnode `subnode1` where 0 is the index of the first element.
<div class="code" src="ValueVectorElement.java"></div>


#### Setting the value of an element.
It is possible to use the method `setValue( ... )` for setting the value content of an element as in the following example:
<div class="code" src="ValueVectorElementSet.java"></div>

#### Getting the value of an element.
Once accessed a vector element (a value in general), it is possible to get its
value by simply using one of the following methods depending on the type of
the content:

- `strValue()`
- `intValue()`
- `longValue()`
- `boolValue()`
- `doubleValue()`
- `byteArrayValue()`.

In the following example we suppose to print out the content of the third element of the subnode `subnode1` supposing it is a string.
<div class="code" src="ValueVectorElementPrint.java"></div>


## Calling an operation of the embedder from the JavaService
A JavaService can be also programmed to call an operation of the embedder. A typical example of such a scenario is the case of a callback pattern between the embedder and the JavaService as reported in the picture below:

<div class="doc_image">
	<img style="width:500px;" src="documentation/architectural_composition/img/firstArchitectureServiceCallback.png" />
</div>


This can be done with the method `sendMessage` of the class `JavaService`. As an example, we extend the previous JavaService by introducing a new asynchronous method called `AsynchHelloWorld` which receives a request with the same message of method `HelloWorld` and a field `sleep` which specifies the number of millisecond to wait before sending the reply. When Such a timeout has been introduced just for simulating a delay in the response. When the sleeping time is finished the method calls back the jolie service on its operation `reply`.
<div class="code" src="JavaServiceCallback.java"></div>

The class `CommMessage` (package `Jolie.net`) represents a Jolie communication message which is sent to the embedder by means of the JavaService method `sendMessage`. The method indeed requires a message which is created by exploiting the static methods `createRequest`. In this case, the message has been initialized with the following parameters:

-   `reply`: the name of the operation of the embedder to call;
-   `/`: the service path (see [Redirection](architectural_composition/redirection.html));
-   `response` : a Value object that contains the data structure to send.

In this case, the message to send contains the same string of method `"HelloWorld`. It is worth noting that in this example the operation *reply* is a **OneWay** operation but it is possible also to interact by using a *RequestResponse* operation. The class `CommMessage` provides different static methods for creating a request message and a response message. Now let us comment how the *FirstJavaServiceInterface* must be modified in order to be compliant with the new JavaService:
<div class="code" src="FirstJavaServiceInterfaceNew.iol"></div>
The new operation `AsyncHelloWorld` has been declared as a OneWay operation and its message type contains two subnodes: `message` and `sleep`. Note that in this case, the corresponding Java method `AsyncHelloWorld` returns a `void` instead of a `Value`.

The embedder follows:
<div class="code" src="JavaServiceCallbackEmbedder.ol"></div>

The embedder must declare its own *inputPort* (here called `MyLocalPort`) where it will receive messages from the JavaService. In particular, on port *MyLocalPort*, the embedder exhibits a OneWay operation called `reply`. In the main scope, the embedder calls the JavaService by means
of the operation `AsyncHelloWorld` and then waits for the reply message on the operation
`reply`.

## Annotations
Each public method programmed within a JavaService must be considered as an input operation that can be invoked from the embedder. Depending on the return object the method represents a OneWay operation or a RequestResponse one. If the return type is `void`, the operation is considered a OneWay operation, a RequestResponse operation otherwise. You can override this behaviour by using
the `@RequestResponse` annotation, which forces Jolie to consider the annotated method as a RequestResponse operation.

## Using RequestResponse operations in JavaServices
So far, we have exploited only OneWay operations for making interactions between the JavaService and the embedder. Now, we present how to exploit also RequestResponse operations. In the example below there are both a RequestResponse invocation from the JavaService to the embedder and a RequestResponse invocation from the embedder to the JavaService. The Java code follows:

<div class="code" src="java_services_1.java"></div>

In this example, the JavaService exhibits a OneWay operation `start` where it prints out the received message and then invokes the embedder by means of the RequestResponse operation `initialize`. The RequestResponse invocation is performed by means of the method `sendMessage` where the string `"Hello world from the JavaService"` is the message content. Since, we are calling a RequestResponse we must synchronously wait for receiving the response message by means of the methods `recvResponseFor` which returns the response message stored into the variable `response`.

## Faults
Faults are very important for defining a correct communication protocol between a JavaService and a Jolie service. Here we explain how managing both faults from the JavaService to the embedder Jolie service and viceversa.

### Sending a Fault from a Javaservice
Let us consider the *FirstJavaService* example where we call the method `HelloWorld` of the JavaService. In particular, let us modify the Java code in order to reply with a fault in case the incoming message is wrong.

<div class="code" src="FirstJavaServiceWithFault.java"></div>

Note that the method `HelloWorld` throws an exception called `FaultException` that comes from the *jolie.runtime* package. A simple Java exception **is not** recognized by the Jolie interpreter as a Fault, only those of FaultException type are. The creation of a *FaultException* is very simple, the constructor can take one or two parameters. The former one is always the name of the fault, whereas the latter one, if present, contains the fault value tree (in the example a message with a subnode `msg`). The fault value tree is a common object of type *Value*. On the jolie service side, there is nothing special but the fault is managed as usual:
<div class="code" src="FirstJavaServiceWithFault.ol"></div>
Keep in mind to modify the *FirstJavaServiceInterface* by declaring the fault `WrongFault` for the operation `HelloWorld`:
<div class="code" src="FirstJavaServiceWithFaultFaultDeclaration.ol"></div>



### Managing fault responses
In Jolie a RequestResponse message can return a fault message which must be managed into the JavaService. Such a task is very easy and can be achieved by checking if the response is a fault or not by exploiting method `isFault` of the class `CommMessage` as reported in the following code snippet:

<div class="code" src="java_services_3.java"></div>

## JavaService dynamic embedding
So far, we have discussed the possibility to statically embed a JavaService. In this case the JavaService is shared among all the sessions created by the embedder. In some cases, it could be particulary suitable to embed an instance of JavaService for each running session of the embedder. Such a task can be fulfilled by exploiting dynamic embedding functionality supplied by the `Runtime` of Jolie. In the following example we present the Java code of a JavaService which simply returns the value of a counter that is increased each time it is invoked on its method `start`.

<div class="code" src="java_services_2.java"></div>

In the following code we report a classical embedding of this JavaService:
<div class="code" src="DynamicJavaServiceClassic.ol"></div>

if we run a client that calls the service ten times as in the following code snippet:
<div class="code" src="DynamicJavaServiceClassicClient.ol"></div>


we obtain:

	Received counter 1
	Received counter 2
	Received counter 3
	Received counter 4
	Received counter 5
	Received counter 6
	Received counter 7
	Received counter 8
	Received counter 9
	Received counter 10

In this case the JavaService is shared among all the sessions and each new invocation will increase its inner counter.

Now let us see what happens if we dynamically embed it as reported in the following service:
<div class="code" src="DynamicJavaServiceDynamicEmbedding.ol"></div>
Note that we included `runtime.iol` in order to exploit `loadEmbeddedService@Runtime` operation. Such an operation permits to dynamically embed the JavaService in the context of the running session. The operation returns the memory location which is directly bound in the location  `DynamicJavaService.location` that is the location of outputPort `DynamicJavaService`.

Now, if we run the same client as in the example before, we obtain the following result:

	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1
	Received counter 1

Such a result means that for each session enabled on the embedder, a new JavaService object is instantiated and executed, thus the counter will start from zero every invocation.
