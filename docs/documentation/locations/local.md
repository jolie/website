## Local location

An embedded service in Jolie can communicate with its embedder exploiting the `local` medium. `local` communications uses the shared memory between embedded and embedder services in order to handle message delivery in an lightweight and efficient way.

The `local` medium has no parameters and needs no protocol when used into a port definition.

An example using this medium can be found in part "Handling structured messages and embedder's operations invocation" of [Embedding Java Services](architectural_composition/embedding_java.html) subsection.

The `local` medium can be used for service internal self communications, as shown in the example below:

<div class="code" src="local.ol"></div>

The operation `hanoi` receives an external http request (e.g., a GET `http://localhost:8000/hanoi?src=source&aux=auxiliary&dst=destination&n=5`) and fires the local operation `hanoiSolver` which uses the `local` location for recursively call itself and build the solution.