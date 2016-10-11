## Automatic generation of a surface
In Jolie, we use the term *surface* to indicate the actual interface that is available at a given inputPort.

Indeed, with advanced architectural composition constructs like [Aggregation](http://docs.jolie-lang.org/#!documentation/architectural_composition/aggregation.html) and [Redirection](http://docs.jolie-lang.org/#!documentation/architectural_composition/redirection.html), an inputPort can support interfaces not directly defined within the correspondent `Interfaces` term. 

In these cases, it might be useful to obtain the actual state of the supported
interfaces --- i.e., all the available operations at a given inputPort --- at runtime. In this way, it is also possible to distribute one comprehensive interface to clients instead of a set of unrelated interfaces. 

The tool `jolie2surface` (present within the standard Jolie installation) performs such merge automatically. The syntax to launch the tool is

<kbd>jolie2surface FILENAME INPUTPORTNAME</kbd>

The surface interface (and a compliant outputPort) will be printed out on the
console. The output can be saved into a file with OS-specific redirection operators, e.g., <kbd>jolie2surface FILENAME INPUTPORTNAME > mySurface.iol</kbd>

### Example
Let us consider the example below, where the inputPort `Aggregator` supports interface `AggregatorInterface` but also aggregates the interfaces of outputPorts `Printer` and `Fax`. 

<div class="code" src="aggregator_inputport_001.ol"></div>

Let `aggregator.ol` be the name of the file containing the code above. Running
`jolie2surface` on inputPort `Aggregator` with <kbd>jolie2surface aggegator.ol
Aggregator</kbd> returns the interface (and the correspondent outputPort) resulting from the merge of the other aggregated interfaces:

<div class="code" src="aggregator_inputport_002.ol"></div>

You can find the comprehensive running example [here](https://github.com/jolie/examples/tree/master/05_other_tools/01_jolie2surface).

