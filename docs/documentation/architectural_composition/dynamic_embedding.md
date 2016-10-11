## Dynamic Embedding
Dynamic embedding allows for the
[embedding](http://docs.jolie-lang.org/#!documentation/architectural_composition/embedding.html)
of a service at runtime. Such a feature is achieved by exploiting the
[Runtime](http://docs.jolie-lang.org/#!documentation/jsl/Runtime.html) library
within the Jolie Standard Library and operation `loadEmbeddedService`, which
reads a microservice file, embeds it, and returns the in-memory location where
it is possible to invoke the microservice. 

To illustrate the application scenarios of dynamic embedding we present two example cases.

## Loading different microservice functions depending on the context
Consider the case in which we support the same interface but the behaviour of the related operations change depending on some context (e.g., if the interaction happen with a mobile device or with a desktop/laptop computer).

In terms of dynamic embedding, this means that a service can choose which sub-service to embed depending on the context of execution.

In the following example we suppose a set of four microservices (`sum.ol`,
`sub.ol`, `mul.ol`, `div.ol`), each implementing the following interface:

<div class="code" src="dynamic_embedding_calc_1.ol"></div>

All the microservices receive two parameters (x and y) and return a result, however, as their names anticipate, they substantially differ on their behaviours: `sum.ol` performs an addition, `sub.ol` calculates the subtraction, and so on.

<div class="code" src="dynamic_embedding_calc_2.ol"></div>

Finally, the coordinator of the four services implements the four different
operations (`sum`, `sub`, ...) and when it receives a new request for one of then, it dynamically embeds the correspondent microservice, runs its behaviour and returns the response. Note that the binding of the outputPort `Operation` with the embedded service is linked to the single session, i.e., 1) parallel requests can embed and bind the outputPort in parallel without disturbing each other and 2) when the response is sent back to the invoker, the embedded service correspondent to that session terminates.

<div class="code" src="dynamic_embedding_calc_3.ol"></div>

## Embedding different instances of a microservice for each open session
We remark that a statically embed service is shared among all sessions created
by the embedder, enabling any of them to access shared (persistent) data. On
the other hand, dynamic embedding lets to associate a unique embedded instance
(session) to the embedder, thus allowing only that specific instance to invoke
the operations of the embedded service.

Let us consider a specification of a service that allows clients to start a timed-counter. The counter sends back to its invoker the value of an incremental count every second.

Let us first illustrate how implementing the desired behaviour with static
embedding does not comply with the given specification. We implement the
specification as an embeddeder with a `concurrent` behaviour, statically
embedding a counter service. A new instance of the embedder is created each
time a new client invokes the `startNewCounter` operation, but still the
embedded service `CounterService` is instanced only once and it is shared among
all the instances of the embedder.

<div class="code" src="dynamic_embedding_1.ol"></div>

Our implementation is wrong because `CounterService` is a singleton, its operations are accessed by any instance of the embedder, thus each instance of the embedder returns a "global" counting, instead of an instance-related one.

With dynamic embedding we can achieve the per-instance behaviour of the specifics.

<div class="code" src="dynamic_embedding_2.ol"></div>

At Lines 15-17 we dynamically embed the service `CounterService` which creates
a new instance of the embedded service each time a new instance of the embedder
is started.

The comprehensive code of both the static (wrong) and dynamic embedding can be downloaded here:

<div class="download"><a href="documentation/architectural_composition/code/dynamic_embedding_code.zip">Dynamic Embedding Code Example</a></div>