## Aggregation

Aggregation is a generalisation of network proxies that allow a service to expose operations without implementing them in its behaviour, but delegating them to other services. Aggregation can also be used for programming various architectural patterns, such as load balancers, reverse proxies, and adapters.

The syntax for aggregation extends that given for input ports.

<div class="syntax" src="syntax_aggregation_1.ol"></div>

Where the `Aggregates` primitive expects a list of output port names.

We can now define how aggregation works. Given IP as an input port, whenever a message for operation OP is received through IP, we have three scenarios:

- OP is an operation declared in one of the interfaces of IP. In this case, the message is normally received by the program.
- OP is not declared in one of the interfaces of IP and is declared in the interface of an output port (OP\_port) aggregated by IP. In this case the message is forwarded to OP\_port port as an output from the aggregator.
- OP is not declared in any interface of IP or of its aggregated output ports. Then, the message is rejected and an `IOException` fault is sent to the caller.

We can observe that in the second scenario aggregation *merges* the interfaces of the aggregated output ports and makes them accessible through a single input port. Thus, an invoker would see all the aggregated services as a single one.

Remarkably, aggregation handles the request-response pattern seamlessly: when forwarding a request-response invocation to an aggregated service, the aggregator will automatically take care of relaying the response to the original invoker.

As an example, here we consider the case of two services, Printer and Fax, which are aggregated together in a service called Aggregator. The code of Printer and Fax services are reported below:

<div class="code" src="aggregation_orchestration_printer_and_fax.ol"></div>

In the aggregator we define an outputPort for each aggregated service (Printer
and Fax). The aggregation is actually defined in the inputPort Aggregator where
we use the keyword `Aggregated` for specifying the list of the aggregated
ports. At runtime, all the messages for operations `print`, `del`, and `fax`
received by the port Aggregator, will be forwarded to services Printer and Fax
respectively.

<div class="code" src="aggregation_orchestration_aggregator.ol"></div>

Note also that aggregator implements another operation called `faxAndPrint`,
which orchestrates the operations of services Fax and Printer. Operation
`faxAndPrint` offers the possibility to call both the services Fax and Printer
atomically where the print operation can be rolled back. Summarising, at the
inputPort `Aggregator`, the aggregator service offers the following operations:
- `print` : supplied by service Printer
- `del`   : supplied by service Printer
- `fax`	  : supplied by service Fax
- `faxAndPrint` : supplied by the aggregator

##jolie2surface
In the previous example, to be able to interact with all operations of the
aggregator, a client must define an outputPort supporting all the available
interfaces of aggregator: `PrinterInterface`, `FaxInterface` and
`AggregatorInterface`. There could be case where we do not want to distribute
all the interfaces separately, but we just want to provide one single interface
which sums up all the operations available at a given port.

The standard installation of Jolie comes with `jolie2surface`, a tool that,
given a Jolie service and the name of an inputPort, it automatically
synthesises a comprehensive interface of all supported operations. See the
related section [jolie2surface](other_tools/jolie2surface.html) for more
details.

## The forwarder, bridging different communication protocols

Aggregation can be used for system integration, e.g., bridging services that use different communication technologies or protocols. The deployment snippet below creates a service that forwards incoming SODEP calls on TCP port 8000 to the output port `MyOP`, converting the received message to SOAP.

<div class="code" src="aggregation_1.ol"></div>

## Aggregation and embedding

We give an example where three services - `A`, `B`, and `C` - are aggregated by a service `M`, which also embeds `C`.

<div class="code" src="aggregation_2.ol"></div>

The code for aggregating services abstracts their actual deployment and remains the same either it is an embedded service (C) or an "external" one (A,B); this abstraction is achieved by setting the aggregation definition on output ports, which uncouples from it both the implementation and the location of the target service.

<div class="doc_image">
	<img src="documentation/architectural_composition/img/aggregation_1.png" />
	<p><b>Fig.1</b> The aggregator <code>M</code> exposes the union of all the interfaces of the services it aggregates (<code>A</code>, <code>B</code>, <code>C</code>). Service <code>C</code> executes inside the virtual machine of <code>M</code>, by embedding. Interfaces are represented with dotted rectangles</p>
</div>

The obtained architectures is graphically represented in Fig.1, where we assume that the aggregated interfaces are singletons.

The grey arrows represent how messages will be forwarded. E.g., an incoming message for operation `op3` will be forwarded to the embedded service `C`.
