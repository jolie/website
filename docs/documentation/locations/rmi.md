## RMI

RMI (Remote Method Invocation) is a Java API provided as an object-oriented equivalent of remote procedure calls.

RMI location name in Jolie's port definition is `rmi`.

---

## RMI locations and protocols

When using RMI Jolie registers the port into a Java RMI Register service. RMI locations are in the form `rmi://hostname:port/name` where the parameter `name` is mandatory and must be unique.

This transport uses its own internal RMI protocol, so theoretically no other protocol needs to be specified. Due to a Jolie parsing restriction, which forces all non-local input ports to have a protocol associated, users may set `Protocol: sodep`.
