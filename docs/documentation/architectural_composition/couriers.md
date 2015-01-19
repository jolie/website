## Courier sessions

Courier sessions allow to compose services independently from the context they belong to, like mandatory procedures (e.g., authentications) and the functionalities of the single services involved.

Courier sessions rely on aggregation and allow an aggregator to handle a special session, called courier session, in which it checks some proprieties of overloaded incoming messages and then forwards them to the aggregated service accordingly.

## Extended interfaces

In order to execute a code block according to the service invoked, the aggregated operations must be *extended*.

`interface extender` is the keyword used in Jolie for extending operations by overloading their types. The overloaded types contain additional fields exploited within the courier session to perform checks and, before forwarding, they are automatically removed from the message. The `interface extender` syntax follows.

<div class="syntax" src="syntax_couriers_1.ol"></div>

The `interface extender` associates an identifier (`extender_id`) to a collection of operations, where `OneWayDefinition` and `RequestResponseDefinition` are respectively the one-way operations definition and request-response operations definition seen in [Communication Ports](basics/communication_ports.html) and Fault handing [Basics](fault_handling/basics.html) subsections.

<div class="syntax" src="syntax_couriers_2.ol"></div>

Then, in the aggregator's deployment, `extender_id` declares to extend the list of operations between curly brackets, followed by the keyword `with`.

Finally, the courier session block is defined in order to forward messages to the operations of the aggregated services:

<div class="syntax" src="syntax_couriers_3.ol"></div>

## A comprehensive example

For a better understanding of how aggregation and interface extension work, let us consider a scenario where a fax service F is part of a trusted intranet, accepting requests coming from any intranet's user.

<div class="code" src="couriers_1.ol"></div>

We can deploy a service that aggregates F in order to keep it unchanged and accept requests from external networks (e.g., the Internet). In this way, we allow external users to invoke F's services, but we introduce security concerns too. To keep the intranet trustworthy, we want to authenticate the external users that use F's service, hence we require additional information than the one needed by F's operations.

In this scenario the "simple" message-forwarding capability of the aggregation is not sufficient. The requests coming from external users cannot be directly forwarded to the aggregated services, as they require some sort of elaboration, which is achieved by extending the operations of the aggregated services in the aggregator.

<div class="code" src="couriers_2.ol"></div>

In the example above, the aggregator exposes the inputPort `AggregatorInput` that aggregates the `Fax` service whose operations types are extended by the `AuthInterfaceExtender`.

`AuthInterfaceExtender` adds an additional node `key` of type `string` to each type of each operation.

The input port uses the field *Interfaces* specifying the additional operation `get_key` that the aggregator provides on its own. That operation is invoked by a client requesting the authentication `key`. The `key` is sent back accordingly to the client's `username` and must be included by the client in every `FaxInterface`'s forward operation.