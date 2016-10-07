## jolie2surface: automatic generation of a surface
A surface is the actual interface that is available at a given inputPort. An inputPort can be joined with more than one interface, or it could also aggregate other outputPorts. In these cases, there not exists a unique interface artifact which summarizes all the available operations at a given inputPort and we are obliged to distribute all the available interfaces to clients instead of one single interface. In the following example we should distribute the interfaces `FaxInterface`, `PrinterInterface` and `AggregatorInterface`.

<div class="code" src="aggregator_inputport.ol"></div>

The tool `jolie2surface` help us in automatically building a unique interface definition.

##How to run jolie2surface
Running jolie2surface is very easy. Just type the following:

```
jolie2surface FILENAME INPUTPORTNAME
```

The surface will be printed out on the console. Use SO redirection operator for saving it in a file

```
jolie2surface FILENAME INPUTPORTNAME > mySurface.iol
```
