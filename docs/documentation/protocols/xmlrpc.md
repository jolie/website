## XML-RPC Protocol

XML-RPC is a remote procedure call protocol encoded in XML (Extensible Markup Language).

Protocol name in port definition: `xmlrpc`.

---

## XML-RPC Transport

XML-RPC has the characteristic that all exchanged variables need to be listed
in a child array `param` (this one becomes XML-RPC's `params` vector). Arrays
need to be passed as child values called `array` eg. `val.array[0] = 1`, in which
case all other eventual child values and the root of a particular value are ignored.

Some other notes to value mapping: Jolie variables of type `long` are unsupported
in XML-RPC and not considered further. Date values (`dateTime.iso8601`) cannot be
generated within Jolie and are considered strings, `base64` values are mapped into `raw`.

This is an example of a primitive XML-RPC server:

<div class="code" src="xmlrpcServer.ol"></div>

---

## XML-RPC Parameters

<div class="code" src="xmlrpc.iol"></div>
