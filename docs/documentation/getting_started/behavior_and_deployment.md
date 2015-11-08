## Behaviour and deployment

A Jolie program defines a service and is a composition of two parts, called *behaviour* and *deployment*.

A behaviour defines the implementation of the functionalities offered by a service; behavioural primitives include communication and computation constructs. However, these do not deal with how communications are supported: they abstractly refer to communication ports, which are assumed to be correctly defined in the deployment part. For example, a behavioural primitive may express the action "ask the calculator service to add the numbers 2 and 6 and then get a result back", without knowing exactly how to reach this calculator service (or which kind of communication protocol it uses).

The deployment part complements the behavioural part, introducing the necessary information for establishing communication links between services and can also be used to define the structure of an SOA.

We give a practical explanation of the difference between behaviour and deployment by creating two services and making them communicate with each other. 

Note that behaviour and deployment are orthogonal: they can be independently defined and can be recombined as long as they match the same type of operations and data.

## Behaviour
Our example is a client-server scenario in which:

- the client invokes the server service, passing a number;
- the server doubles the received number and sends the result back to the client.

### Server

<div class="code" src="behaviour_and_deployment_server_behaviour.ol"></div>

The server's behaviour starts with an input on operation `twice`, storing the received message in variable `number`. Thereafter, it stores in variable `response` the value of `number` multiplied by 2. Finally, `response` value is sent back to the initial invoker of `twice`.

### Client

<div class="code" src="behaviour_and_deployment_client_behaviour.ol"></div>

Complementary to the server's behaviour, the client's behaviour consists in invoking the operation `twice` exposed by the server, passing the number 5 as the invocation value. After sending the request to the server, the operation will wait for a response, storing it in the variable `response`. Finally, the result is printed on screen (Line 4).
For a thorough explanation of the usage of operations, see section [Communication Ports](basics/communication_ports.html).

## Deployment

The communication primitives in behaviours are concretely supported by communication ports.

There are two kinds of ports: *input ports* expose input operations to other services, and *output ports* define how to invoke the operations of other services. Input and output ports are dual concepts and their syntaxes are quite similar. Ports are based upon the three fundamental concepts of *location*, *protocol* and *interface*. The former two define the concrete binding information between a Jolie program and other services. The last, instead, defines type information that is expected to be satisfied by the behaviour that uses the ports.

A location, e.g. a TCP/IP address, expresses the communication medium that a service uses for exposing its interface or contacting another service.

A protocol defines how data to be sent or received should be encoded (output) or decoded (input).

Finally, a port must specify the interface that is accessible through it. For a thorough explanation of interfaces, see section [Communication Ports](basics/communication_ports.html). 

In our example the `TwiceInterface` interface declares the operation `twice` as a request-response operation. A request-response operation receives a request and sends back a response. Both input and output messages of `twice` are typed as `int` (denoting integers):

<div class="code" src="behaviour_and_deployment_twiceInterface.iol"></div>

Finally below follow both server's and client's deployment code.

### Server

<div class="code" src="behaviour_and_deployment_server_deployment.ol"></div>

### Client

<div class="code" src="behaviour_and_deployment_client_deployment.ol"></div>

The two declarations are very similar: they share the same of location, protocol, and interface.

## Putting it all together

We can now give the complete programs for client and server by putting together their respective deployment and behaviour parts.

## Server\'s code

<div class="code" src="behaviour_and_deployment_server.ol"></div>

## Client\'s code

<div class="code" src="behaviour_and_deployment_client.ol"></div>

The two programs can be downloaded from the link below:

<div class="download"><a href="documentation/getting_started/code/behaviour_and_deployment_code.zip">Behaviour and Deployment Code Example</a></div>

We can now run the two programs in two separate shells. Note that it is important to start `server.ol` before `client.ol`, since the server must be ready to receive an invocation before the client tries to reach it.
