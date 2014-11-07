## Embedding

Embedding is a mechanism for executing multiple services in the same virtual machine. A service, called *embedder*, can *embed* another service, called *embedded* service, by targeting it with the `embedded` primitive.

The syntax for embedding is:

<div class="syntax" src="syntax_embedding_1.ol"></div>

the embedding construct specifies the type (`Language`) of the service to embed, and `path` is a URL (possible in simple form) pointing to the definition of the service to embed. Jolie currently supports the embedding of `Jolie`, `Java`, and `JavaScript` service definitions.

Embedding may optionally specify an output port: in this case, as soon as the service is loaded, the output port is bound to the "local" communication input port of the embedded service. The meaning of local communication input port is dependent on the embedding type.

This makes embedding a *cross-technology* mechanism: it can load services defined using different languages. Embedding produces a hierarchy of services where the embedder is the parent service of embedded ones; this hierarchy handles termination: whenever a service terminates, all its embedded services are recursively terminated. The hierarchy is also useful for enhancing performances: services in the same virtual machines may communicate using fast local memory communication channels.

Command line parameters can also be passed. Local in-memory communication between embedder and embedded is enabled by means of the `local` communication medium, which must be specified by the embedder service. In this case no protocol definition is needed.