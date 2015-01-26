## Frequent Asked Questions

**Why a new language and not simply a new library/framework for, e.g., Java?**

Jolie is interoperable with JVM-based languages (and more, e.g., Javascript, in the near future Python and others).

A language is necessary to impose constraints and provide well-formed abstractions.

Here the central abstraction is that all programs are microservices by construction and then there are native primitives for composing and deploying microservices.

<code>MAYBE AN EXAMPLE COULD HELP</code>

If you like, you can see Jolie as Java library that you can use with the syntax of the Jolie language. Since it runs on the JVM you can access and reuse any code base from/to Java (and other JVM-based languages) using the Jolie APIs.

The reason for a specific language is to have clean definitions. If we implemented Jolie as a library for another general-purpose language, the developer can always break from the abstractions we provide. This occurrence would easily break the type system or whatever else supporting mechanism the language comes with, eventually nullifying the purpose of our work.

For instance, consider the definition of [interfaces](http://docs.jolie-lang.org/#!documentation/basics/communication_ports.html#interfaces). It is designed to ensure that all Jolie messages can be handled by all the different protocols that we support -- e.g., HTTP (GWT, some REST-based things, XML, JSON, ...), SODEP (a binary protocol) -- and communication mediums -- e.g., local sockets, TCP/IP sockets, bluetooth, local memory.

But we paid attention to not re-inventing the wheel when not necessary. 

**Is Jolie some kind of [Enterprise Service Bus](http://en.wikipedia.org/wiki/Enterprise_service_bus) 2.0.?**
**What is the relation between Jolie and an ESB?**

Not quite, but definitely related.

There are some shared ideas, like integration is a central piece of the puzzle, but Jolie is not an ESB (although you could easily program an ESB using the primitives that Jolie provides, and also Jolie can be easily used inside of existing ESBs!).

It is instead a general-purpose programming language, interoperable with JVM-based languages.