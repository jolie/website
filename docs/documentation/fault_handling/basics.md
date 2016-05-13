## Fault Handling

Basic fault handing in Jolie involves three concepts: *scope*, *fault* and *throw*.

## Scope, fault and throw

A `scope` is a behavioural container denoted by a unique name and able to manage faults. Remarkably, in a service behaviour, the `main` is a scope named *main*. We say that a scope terminates successfully if it does not raise any fault signal; a scope obtains this by handling all the faults thrown by its internal behaviour.

A fault is a signal, identified by its name, raised by a behaviour towards the enclosing scope when an error state is reached, in order to allow its recovery.

Jolie provides the statement `throw` to raise faults.

Scope and throw syntax follows.

<div class="syntax" src="syntax_basics_1.ol"></div>

---

## Fault handlers

The `install` statement provides the installation of dynamic fault handlers, where `install` joins a fault to a process and its handler is executed when the scope catches the fault.

<div class="syntax" src="syntax_basics_2.ol"></div>

A fault which is not caught within a scope, is automatically re-thrown to the parent scope. In the following example, a simple service asks the user to insert a number, if the number does not correspond to the `secret` one, a fault is raised.

<div class="code" src="basics_1.ol"></div>

### Install statement priority

An install statement may execute in parallel to other behaviours that may throw a fault. This introduces a problem of nondeterminism: how can the programmer ensure that the correct handlers are installed regardless of the scheduling of the parallel activities? Jolie solves this issue by giving priority to the install primitive with relation to the fault processing, making handler installation predictable.

As an example, consider the following code:

<div class="code" src="basics_5.ol"></div>

where, inside the scope `s`, we have a parallel composition of a `throw` statement for fault `f` and an installation of a handler for the same fault. The priority given to the install primitive guarantees that the handler will be installed before the fault signal for `f` reaches the scope construct and its handler is searched for.

---

## RequestResponse Pattern and transmission of data into a fault

Uncaught fault signals in a request-response body are automatically sent to the invoker. Hence, invokers are always notified of unhandled faults. We update the syntax given for request-response operation types to declare the faults that could be sent back to invokers along with their data type.

<div class="syntax" src="syntax_basics_3.ol"></div>

Let us modify the previous example in order to introduce a request-response operation.

<div class="code" src="basics_2.ol"></div>

The interface defines the operation `guess` able to throw a `NumberException`, whose message type is `NumberExceptionType`.

<div class="code" src="basics_3.ol"></div>

The server implements the throw statement in the else branch of operation `guess` behaviour. If the number sent by the client is different than the `secret` one, the request-response operation will send a `NumberException`
fault to the client along the fault data.

The syntax for joining data into a fault is a simple extension of the `throw` syntax given previously.

<div class="syntax" src="syntax_basics_4.ol"></div>

Let us write a client that handles the raise of the fault and prints the data sent from it:

<div class="code" src="basics_4.ol"></div>
 
As shown at Line 15, in order to correctly reference fault data within a fault handler, it is necessary to specify the scope path where the fault is contained.

## Accessing a fault caught in a scope

It is possible to check if scopes caught faults and also to access the contents of faults.

With syntax `scope_name.default` we access the name of the fault caught by the scope.

Used in combination with [dynamic lookup](#!documentation/basics/data_structures.html#dynamic-look-up), with syntax `scope_name( scope_name.default ).faultMessage`, we can access the message sent with the fault, for instance `msg` in the example below.

<div class="code" src="basics_6.ol"></div>



