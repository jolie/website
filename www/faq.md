<!--Themed-->

# Frequently Asked Questions (FAQ)


## Is Jolie compatible with this _language_ or _framework_?

The Jolie interpreter is implemented in Java, and it comes with a Java API to interact with it.
So Jolie is basically interoperable with everything that is compatible with Java (the JVM-based implementations of Javascript, Python, etc.).
For example, with Java, it is possible to run Java code from inside of Jolie and vice versa, run Jolie from inside of a Java program using our Java API.

The best supported languages are currently Java and Javascript, but there is nothing that prevents adding others (e.g., Python, Ruby, Scala).

We usually interact with C/C++ through the normal Java means (e.g., the Java Native Interface).

This said, remember that Jolie is a language based on communications and that it supports many different communication technologies and protocols.
You can therefore always integrate with other software by means of communicating, e.g., HTTP, SOAP, or SODEP messages.

## Why a new language and not just a new library/framework (e.g., in Java)?

A language is necessary to impose constraints and use them to build powerful abstractions.
In Jolie, the central abstraction is that all programs are microservices by construction. Microservices can then be composed and deployed with native language primitives.

An example of why this is useful is that programmers cannot break loose coupling: two Jolie microservices cannot _share_ data, they can only _exchange_ data by communicating. Data can be shared only among processes in the same microservice. This prevents having hidden shared data structures that can break thread-safety and reusability.

Another example comes from our [interfaces](http://docs.jolie-lang.org/#!documentation/basics/communication_ports.html#interfaces). It is designed to ensure that all Jolie messages can be handled by all the different protocols that we support -- e.g., HTTP (GWT, some REST-based things, XML, JSON, ...), SODEP (a binary protocol) -- and communication mediums -- e.g., local sockets, TCP/IP sockets, bluetooth, local memory.
Then, our composition primitives (e.g., [aggregation](http://docs.jolie-lang.org/#!documentation/architectural_composition/aggregation.html)) can be used to build complex systems without having to worry about the underlying communication details of the included microservices.

We also paid attention at not re-inventing the wheel when not necessary. Since Jolie offers a Java API and can be run from inside of a Java program, you can also see Jolie as a Java library that you can use with the syntax of the Jolie language.

## What is the relation between Jolie and Enterprise Service Bus?

There are some shared ideas between Jolie and [ESB](http://en.wikipedia.org/wiki/Enterprise_service_bus), like integration is a central piece of the puzzle, but Jolie is not an ESB.
Jolie is a programming language, so if you wanted you could _build_ your own ESB using the primitives that Jolie provides. Jolie can also be used inside of existing ESBs.

## Wouldn't this style of programming take a lot of performance away?

Jolie adds a layer of indirection that, albeit thin, introduces a performance cost.
It is not something that we have noticed in the production environments using Jolie so far, as Jolie also introduces performance benefits that act as counterweight. For example, the fact that the interpreter automatically handles communication channels implicitly (e.g., sockets), introduced the opportunity for many optimisations (for example, we reuse channels whenever possible even on different sessions and processes).

Nevertheless, there is surely a lot of space for improvement, as that thin layer of abstraction is not something that the language imposes but rather an implementation detail. In the future, we plan on removing it entirely for local code execution via parser/compiler optimisations. This is the same situation as for many other languages, where abstractions presented a performance hit at the beginning but with time they can be optimised so much that they are not relevant for most use cases.

Please note that Jolie comes with good integration capabitilies for a reason: so that you can use the right tool for the right problem.
You will probably find yourself more comfortable in implementing a performance-critical algorithm using C or Java (or your language of choice), integrating it in Jolie (using, e.g., [embedding](http://docs.jolie-lang.org/#!documentation/architectural_composition/embedding.html)),
and finally using Jolie to deal with communications in your system.
