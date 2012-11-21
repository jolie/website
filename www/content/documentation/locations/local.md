## Local location

An embedded service in Jolie can communicate with its embedder exploiting the `local` medium. `local` communications exploit the shared memory between the services in order to handle their message delivery in an lightweight and efficient way.

The `local` medium has no parameters.

An example using this medium can be found in part "Handling structured messages and embedder's operations invocation" of [Embedding Java Services](architectural_composition/embedding_java) subsection.