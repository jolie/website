## JavaServices

<div class="panel panel-primary">
	<div class="panel-heading">
 	<p class="panel-title">Attention</p>
	</div>
	<div class="panel-body">
 	This documentation page is a stub. Its contents can be partial and/or out of date.
	</div>
</div>
What follows is a brief tutorial that comprises how to develop JavaService classes in an IDE and use them within Jolie programs.
The tutorial also presents some features of Java integration in Jolie, i.e., manipulating Jolie values in Java, calling operations from a Java service, and the dynamic embedding of JavaServices.

### The first JavaService

We use [Netbeans IDE](http://www.netbeans.org) to create our first JavaService.

#### Creating a new project

First of all, we need to create a new Java Application project with
Netbeans:

<!--![](./images/JavaServices_netbeans1.jpeg)-->

**Figure JavaServices.1**: Netbeans project creation mask.

Then, we name the project, e.g., `FirstJavaService`, and we add to its
*Libraries* the Jolie project present in Jolie installation folder. The Jolie
installation folder contains the Java abstract class `JavaService`
(`Jolie.runtime.JavaService`). We will implement it to create our JavaService.

#### Creating a new package

Before writing down the code of the JavaService, we create the
package which will contain it.

<!--![](./images/JavaServices_netbeans2.jpeg)-->

**Figure JavaServices.2**: Creation of the package `Jolie.example`.

#### Creating the Java file

Then, we create the Java file and we name it with same name of the
JavaService that is `FirstJavaService`.

<!--![](./images/JavaServices_netbeans3.jpeg)-->

**Figure JavaServices.3**: Creation of the Java file.

#### Writing the Java code and building it

In the following, we add some logic to the JavaService, i.e., printing out a
message on the console. The Java code follows:

`MISSING CODE`

Finally we can build the Java file into a `.jar` file.

#### Executing the JavaService

To execute the JavaService we have to embed it into a Jolie service which
invokes it as a common embedded service as described in
[Embedding](architectural_composition/embedding.html). The Jolie embedder service
can call all the public methods of the JavaService like operations of Jolie
services.

In particular, this example has one public method called *write* which can be
easily invoked by the following embedder:

[Download code](#code_JavaServices_1.zip)

Note that the embedded construct takes as a type the keyword Java
instead of Jolie because we are embedding a JavaService. As parameter
the embedded construct takes the absolute class name obtained as
`package/name+class/name`. As for a Jolie service, the embedder must
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