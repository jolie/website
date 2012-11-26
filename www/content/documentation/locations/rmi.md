## RMI

RMI (Remote Method Invocation) is a Java API provided as an object-oriented equivalent of remote procedure calls.

Protocol name in Jolie port definition: `rmi`.

---

## RMI locations

When using RMI Jolie registers the port into a Java RMI Register service. RMI locations are in the form `rmi://hostname:port/name` where the parameter `name` is mandatory and must be unique.