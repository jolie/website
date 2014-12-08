## Dynamic binding

Jolie allows output ports to be dynamically bound, i.e., their locations and protocols (called *binding informations*) can change at runtime. Changes to the binding information of an output port is local to a behaviour instance: output ports are considered part of the local state of each instance. Dynamic binding is obtained by treating output ports as variables. For instance, the following would print the location and protocol name of output port `Printer`:

<div class="code" src="dynamic_binding_1.ol"></div>

Binding information may be entered at runtime by making simple assignments:

<div class="code" src="dynamic_binding_2.ol"></div>

---

## The binding registry example

We show a usage example of dynamic binding and binding transmission by implementing a binding registry, i.e., a service that shares binding information. The registry offers a request-response operation, `getBinding`, that returns the binding information for contacting a service. We identify service by simple names. The interface of the registry is thus:

<div class="code" src="dynamic_binding_3.ol"></div>

where `Binding` is the type of port bindings defined in the standard Jolie library. Below we implement the registry behaviour, which supplies binding information for an inkjet printer and a laser printer (whose services we leave unspecified).

<div class="code" src="dynamic_binding_4.ol"></div>

Finally, we define a client that calls `getBinding` for discovering the laser printer:

<div class="code" src="dynamic_binding_5.ol"></div>