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


/////////////////////////////////

[Download code](#code_JavaServices_1.zip)

 As for a Jolie service, the embedder must
declare the interface of the embedded service and the outputPort used
for communicating with it. In this case the interface contains a OneWay
operation called write whereas the outputPort is called
`MyFirstJavaServicePort`. It is worth noting that the embedder must be
run by passing the JavaService jar file as a parameter by using the
option `-l` as shown below:

`MISSING CODE`

## Manipulating Jolie values in Java

So far, we have sent a very simple message to the JavaService that is a
string. But, it could be useful to send an entire Jolie value tree.
Before showing the way for accomplishing this issue, we have to
introduce the Java class `Value`. Such a class allows for the
manipulation of Jolie value trees in Java.

#### Creating a value.
First of all, we need to create a Value in Java as we would do in
Jolie. The following Java code creates a Value.

#### Getting the vector elements.
In each Jolie tree, a node is a vector. In order to access/get the
vector elements of a node, you can use the method `getChildren( String
subnodeName )` which returns the corresponding `ValueVector` of the
subnode `subnondeName`. In the following example we get all the vector
elements of the subnode `subnode1`.

In order to access the element at index *i* it is possible to use the
method `get( int index )`. In the following example we access the third
element of the subnode `subnode1`.

It is worth noting that an element of a ValueVector is a Value and that
the first element of a `ValueVector` is the element at the index 0.

#### Getting the value of an element.
Once accessed a vector element (a value in general), it is possible to get its
value by simply using one of the following methods depending on the type of
the content:

- `strValue()`;
- `intValue()`;
- `longValue()`;
- `boolValue()`;
- `doubleValue()`.

In the following example we suppose to print out the content of the second
element of the subnode `subnode1` supposing it is a string.

#### Setting the value of an element.
Analogously, it is possible to use the method `setValue( ... )` for
setting the value content.

## Calling an operation of the embedder from the JavaService

A JavaService can be also programmed to call an operation of the embedder.
This can be done with the method `sendMessage` of the class `JavaService`.
Such a feature is particularly useful when we want to create a JavaService
which has an active role instead of always waiting to be invoked by the
embedder. As an example, we extend the previous JavaService by introducing an
invocation of a OneWay operation of the embedder called `writeBack`:

`MISSING CODE`

The class `CommMessage` (package `Jolie.net`) represents a Jolie communication
message which is sent to the embedder by means of the JavaService method
`sendMessage`. The method indeed requires a message which is created by
exploiting the static methods `createRequest`. In this case, the message has
been initialized with the following parameters:

-   `writeBack`: the name of the operation of the embedder to call;
-   `/`: the service path (see [Redirection](architectural_composition/redirection.html));
-   `v` : a Value object that contains the data structure to send.

In this case, the message to send contains a string: `"Hello world from the
JavaService<!--!"`. The class `CommMessage` provides different static methods for-->
creating a request message and a response message. In this example, we have
created a request message because the JavaService invokes a OneWay operation
of the embedder. The embedder follows:

`MISSING CODE`

The embedder must declare its own `inputPort` where it will receive messages
from the embedded service. The embedder exhibits a OneWay operation called
`writeBack`. In the main procedure, the embedder calls the JavaService by means
of the operation `write` and waits for a message on the operation
`writeBack`.

[Download code](#code_JavaServices_2.zip)

## Annotations

Each public method programmed within a JavaService must be considered as an
input operation that can be invoked from the embedder. Depending on the return
object the method represents a OneWay operation or a RequestResponse one. If
the return type is `void`, the operation is considered a OneWay operation, a
RequestResponse operation otherwise. You can override this behaviour by using
the `@RequestResponse` annotation, which forces Jolie to consider the annotated
method as a RequestResponse operation.

## Using RequestResponse operations in JavaServices

So far, we have exploited only OneWay operations for making interactions
between the JavaService and the embedder. Now, we present how to exploit
also RequestResponse operations. In the example below there are both a
RequestResponse invocation from the JavaService to the embedder and a
RequestResponse invocation from the embedder to the JavaService. The
Java code follows:

<div class="code" src="java_services_1.java"></div>

In this example, the JavaService exhibits a OneWay operation `start` where it
prints out the received message and then invokes the embedder by means of the
RequestResponse operation `initialize`.

The RequestResponse invocation is performed by means of the method
`sendMessage` where the string `"Hello world from the JavaService"` is the
message content. Since, we are calling a RequestResponse we must wait for
receiving the response message by means of the methods `recvResponseFor` which
returns the response message stored into the variable `response`. Moreover,
the JavaService exhibits the RequestResponse operation `write` where it prints
out the received message and returns the string `"Hello world from the write
operation of the JavaService<!--!"`. -->

The exhibited RequestResponse operation returns a Value object which contains
the response message. The code of the embedder follows:

`MISSING CODE`

The JavaService interface declares both the OneWay operation `start` and the
RequestResponse `write`. Moreover, the embedder exhibits a RequestResponse
operation called `initialize`. In the behaviour, the embedder calls the
operation `start` of the JavaService and then waits for a message on the
operation `initialize`. At the end, the embedder invokes the operation `write`
of the JavaService. Here we provide the code to be downloaded. In the zip file
we also provide the pre-built jar file of the JavaService, thus it is possible
to execute the embedder by specifying the jar to be used in the command line
as it follows:

<kbd>Jolie embedder.ol -l Example3.jar</kbd>

[Download code](#code_JavaServices_3.zip)

### Managing fault responses
In Jolie a RequestResponse message can return a fault message which
must be managed into the JavaService. Now, let us suppose to modify the
`embedder.ol` by throwing the fault `MyFault` as response into the body
of the `initialize` operation as it follows:

<div class="code" src="java_services_1.ol"></div>

Clearly, we have also to enhance the interface in order to declare that
operation `initialize` can raise a fault as shown below:

<div class="code" src="java_services_2.ol"></div>

After enabling fault raising into `embedder.ol`, we simply modify the
JavaService by checking if the response is a fault or not by exploiting
method `isFault` of the class `CommMessage` as we do in the following
Java code:

<div class="code" src="java_services_3.java"></div>

## JavaService dynamic embedding

So far, we have discussed the possibility to statically embed a
JavaService. In this case the JavaService is shared among all the
sessions created by the embedder. It could be particulary suitable to
embed a different JavaService for each embedder session. Such a task can
be fulfilled by exploiting dynamic embedding functionality supplied by
the `runtime`. In the following example we present the Java code of a
JavaService which simply returns the value of a counter which is
increased each time it is invoked on its method `start`.

<div class="code" src="java_services_2.java"></div>

Now we dynamically embed this JavaService in the following service where for
each session opened on operation `run` the JavaService is dynamically embedded
and called on the operation `start`.

If we create a simple client which calls this service for ten times we
will have the following result on the console:

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

Such a result means that for each session enabled on the embedder, a new
JavaService object is instantiated and executed. Indeed, we can try to execute
the same client on a embedder service which statically embed the JavaService,
the result will be:

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

In this case the JavaService is shared among all the sessions and each
new invocation will increase its inner counter. In the following you can
download the code and try yourself.

[Download code](#code_JavaServices_4.zip)
