## Jolie Protocols

A protocol defines how data to be sent or received shall be, respectively, encoded or decoded, following an isomorphism.

Jolie natively supports a large set of protocols:

- HTTP;
- HTTPS;
- JSON/RPC;
- XML/RPC;
- SOAP;
- SODEP;
- SODEPS.

Each protocol has its own parameters that can be set in order to adapt to the requirements of the communications.

In this section we explain what parameters can be set for each protocol.

## Setting (static) parameters

The parameters of the protocol are specified in the input/output [port](basics/communication_ports.html) definition. Unless required, if a parameter is not defined it is set to its default value according to its protocol specification.

Let us recall the examples given in [HTTP GET/POST Requests](web_applications/web_get_post.html) where we set the parameters `method` and `format`, of protocol `http`, to define what kind of messages the port shall send or receive.

<div class="code" src="protocols_1.ol"></div>

In the example above, we statically set - with an assignment `=` - some of http protocol's parameters in order to send `get` and `post` requests or to define what kind of requests will be received.

Besides defining a parameter as a static value, which remains the same during the whole execution of the program, we can exploit Jolie runtime variable evaluation to change them according to our application behaviour.

---

## Setting dynamic parameters

Protocol's parameters can be set dynamically using the alias `->` operator.

To exemplify how to dynamically set the parameters of a protocol, we refer to the [Leonardo](web_applications/leonardo.html)'s inputPort definition:

<div class="code" src="protocols_2.ol"></div>

As shown, except `keepAlive`, `debug.showContent`, and `default` parameters that are statically set, all other parameters are aliased to a variable whose value can be changed at runtime, during Leonardo's execution.

Besides aliasing protocol's parameter, we can access and modify them using the standard Jolie construct for [dynamic port binding](basics/dynamic_binding.html).