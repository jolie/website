## Collections

[Courier Sessions](architectural_composition/couriers.html) can be used in combination with *collections* of output ports in order to forward them according to a specific rule.

A collection is a set of output ports that share the same interface.

## Smart Aggregations

Collections extend the Courier Sessions syntax by allowing a set of output ports that share the same interface to be extended by the same `interface_extender`,

<div class="syntax" src="syntax_collections_1.ol"></div>

then, in the courier definition, the forward statement specifies the corresponding output port to forward the message to.

<div class="syntax" src="syntax_collections_2.ol"></div>

Courier Sessions that use collections of output ports are called "smart aggregations".

## A comprehensive example

Let us modify the example shown in Couriers subsection. In this new scenario we have two printer services Printer1 and Printer2, and the fax service Fax which are part of our trusted intranet.

<div class="code" src="collections_1.ol"></div>

We deploy a service that aggregates Printer1, Printer2, and Fax to accept requests from external networks (e.g., the Internet), but we want to authenticate the external users that use Printer1's and Printer2's service.

<div class="code" src="collections_2.ol"></div>

Above, the aggregator exposes the inputPort `AggregatorInput` that aggregates the `Fax` service (as is) and `Printer1` and `Printer2` services. `Printer1`'s and `Printer2`'s operations types are extended by the `AuthInterfaceExtender`.

The comprehensive files of the example above can be downloaded from the following link:

<div class="download"><a href="documentation/architectural_composition/code/aggregation_code.zip">Aggregation and interface extender Code Example</a></div>