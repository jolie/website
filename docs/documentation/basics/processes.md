## Behaviour instances

A service participates in a session by executing an instance of its behaviour. So far we have executed behaviours a single time, which means that each service we run supported only a single session. If needed again, the service must be executed manually another time.

Jolie allows to reuse behavioural definition multiple times with the *execution modality* deployment primitive, whose syntax is:

<div class="syntax" src="syntax_processes_1.ol"></div>

`single` is the default execution modality (so the `execution` construct can be omitted), which runs the program behaviour once. `sequential`, instead, causes the program behaviour to be made available again after the current instance has terminated. This is useful, for instance, for modelling services that need to guarantee exclusive access to a resource. Finally, `concurrent` causes a program behaviour to be instantiated and executed *whenever its first input statement can receive a message*.

<div class="attention"><p>In the `sequential` and `concurrent` cases, the behavioural definition inside the main procedure must be an input statement.</p></div>

A crucial aspect of behaviour instances is that each instance has its own private state, determining variable scoping. This lifts programmers from worrying about race conditions in most cases.

For instance, let us recall the server program given at the end of [Communication Ports](basics/communication_ports.html) section. We can simply add the deployment instruction `execution{ concurrent }` to the server's deployment to make it supporting multiple clients at the same time. Access to variables would be safe since each behaviour instance would have its private state.

<div class="code" src="processes_1.ol"></div>

---

## `init{}`

Jolie also supports special procedures for initialising a service before it makes its behaviours available. The `init{}` scope allows the specification of such procedures. All the code specified within the `init{}` scope is executed only once, when the service is started.

---

## Global variables

Jolie also provides *global variables* to support sharing of data among different behaviour instances. These can be accessed using the `global` prefix:

<div class="code" src="processes_3.ol"></div>

---

## Synchronisation 

Concurrent access to global variables can be restricted through `synchronized` blocks, similarly to Java:

<div class="syntax" src="syntax_processes_2.ol"></div>

The synchronisation block allows only one process at a time to enter any `synchronized` block sharing the same `id`.

---

## A comprehensive example

Let us consider a comprehensive example using the concepts explained in this section. 

The register service has a concurrent execution and exposes the `register` request-response operation. `register` increments a global variable, which counts the number of registered users, and sends back a response to the client.

*regInterface.ol*

<div class="code" src="processes_4.ol"></div>

*server.ol*

<div class="code" src="processes_2.ol"></div>

*client.ol*

<div class="code" src="processes_5.ol"></div>

The programs can be downloaded from the link below:

<div class="download"><a href="documentation/basics/code/processes_code.zip">Processes Code Example</a></div>

Once extracted, the two programs may be run in two separate shells. Make sure to start `register.ol` before `client.ol`. Try to start more than one `client.ol` at once and see the results.