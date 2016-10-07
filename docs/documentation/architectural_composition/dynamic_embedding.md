## Dynamic Embedding
Dynamic embedding allows for the embedding of a service at runtime. Such a feature is achieved by
exploiting the Runtime microservice library which is released together with the jolie interpreter.
In particular, the operation loadEmbeddedService reads a microservice file, embeds it and returns
the in-memory location where it is possible to invoke the microservice. In order to explain such
a feature, in the following we show two possible scenarios where it is used.

## Loading different microservice functions depending on the context
This is the case where we could have several microservices which implements the same interface but with different behaviour. Depending on the execution context of the parent service, a different microservice will be embedded. In the following example we suppose a list of four microservices (sum.ol, sub.ol, mul.ol, div.ol) which implements the following interface:

<div class="code" src="dynamic_embedding_calc_1.ol"></div>

All the microservices receive two parameters (x and y) and return a result. They just differ in the behaviour: the sum.ol will perform a sum between x and y, the sub.ol will perform a subtraction and so on.

<div class="code" src="dynamic_embedding_calc_2.ol"></div>

The server implements four different operations and depending on which of them is invoked it will embed a different microservice.

<div class="code" src="dynamic_embedding_calc_3.ol"></div>


## Embedding different instances of a microservice for each open session
In the previous subsections we showed how to statically embed services. A statically embedded service is shared among all sessions created by the embedder, enabling any of them to access shared (persistent) data.

Dynamic embedding makes possible to associate a unique embedded instance (session) to the embedder, thus allowing only that specific instance to invoke the operations of the embedded service.

Let us consider a specification of a service that allows clients to start a timed-counter. The counter sends back to its invoker the value of an incremental count every second.

First, we implement the specification as an embeddeder with a `concurrent` behaviour, statically embedding a counter service. A new instance of the embedder is created each time a new client invokes the `startNewCounter` operation, but still the embedded service `CounterService` is instanced only once and it is shared among all embedder's instances.

<div class="code" src="dynamic_embedding_1.ol"></div>

Such an implementation is wrong because it diverges from the given specification.

`CounterService` is a singleton, its operations are accessed by any instance of the embedder, thus each instance of the embedder returns a "global" counting, instead of a single-instanced one.

We can achieve the right implementation by dynamically embedding the service.

<div class="code" src="dynamic_embedding_2.ol"></div>

In the example above we include the `runtime.iol` library (part of Jolie's standard library ) used for realizing the dynamic embedding. At Lines 15-17 we dynamically embed the service `CounterService` which creates a new instance of the embedded service each time a new instance of the embedder is started.

The comprehensive code examples of both the static (wrong) and dynamic embedding can be downloaded here:

<div class="download"><a href="documentation/architectural_composition/code/dynamic_embedding_code.zip">Dynamic Embedding Code Example</a></div>
