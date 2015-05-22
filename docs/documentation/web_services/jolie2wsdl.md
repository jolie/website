## Jolie2wsdl

Jolie2wsdl is the counterpart of [wsdl2jolie](web_services/wsdl2jolie.html) tool. It allows the creation of a WSDL document starting from a Jolie Interface.

## The syntax

---

The syntax of jolie2wsdl follows:

<div class="syntax" src="syntax_jolie2wsdl.ol"></div>

where:

- `-i include_file_path` must be set if the jolie service includes `.iol` files belonging to Jolie standard library (e.g., `console.iol`). For example this path, in a Linux environment, is `/opt/jolie/include`;
- `--namespace target_name_space` name of WSDL namespace used by jolie types
- `--portName name_of_the_port` name of the port that is exposing the inferface callable via SOAP
- `--portNane name_of_the_port` address of the listening port 
- `--o output_filename` is the file name  where the generated WSDL document is stored (`MyWsdl.wsdl` is the default value).
- `filename.ol` is the jolie service file whose input port must be transformed into a soap one

## Jolie interface guidelines

When programming a Jolie interface to be transformed into a WSDL document, its recommended to follow these guidelines:

Native types in operation declaration are not permitted. For example, the following declaration is forbidden:

<div class="code" src="jolie2wsdl_1.ol"></div>

All complex types must have a void value in the root. Hence, the following declaration are not permitted:

<div class="code" src="jolie2wsdl_2.ol"></div>

Thus, the right types and interface declaration for our example may be:

<div class="code" src="jolie2wsdl_3.ol"></div>
