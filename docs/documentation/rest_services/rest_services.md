## Jester
Jolie does not natively support REST microservice programming, but it is very easy to deploy a service as a REST services by using some added tools.

The project Jester - the Jolie rEST routER (and related tools) - which can be found here [Jester](https://github.com/jolie/jester) introduces some useful tools for dealing with REST services in Jolie. In the following we report the documentation.

## jolie2rest
This tool allows for the creation of:
- a declaration for the REST router in order to automatically publish an existing jolie microservice into the router
- a Swagger interface which reports all the API published in the router

Usage: jolie jolie2rest.ol router_host [swagger_enable=true|false] [easy_interface=true|false]
Ex:
`jolie jolie2rest.ol localhost:8080 swagger_enable=true easy_interface=false`

It is worth noting that the parameter router_host identifies the location where the router is listening for, it does not represent the location of the target service.
The tool will get the lits of the service to be analyzed from the file
`service_list.txt`

Each line of the file service_list.txt represents a service to be analyzed, in particular the line syntax is: path of the ol file of the service , name of the input port to be analyzed
EX:
`./demo/demo.ol, DEMO`

It is important to highlight that a microservice can have more than one inputPort with different operations declared in it. If more inputPorts must be analyzed, then a line for each of them must be reported into the file service_list.txt.

## REST annotations on the jolie interface
In order to allow for the publishing of a jolie operation in a REST modality it is necessary to annotate each operation of the interfaces to be published as it follows:

`/**! @Rest: method=[post|get|put|delete] [,template=...]; */`

where:
* `/**! [...] */`  are the tokens to be used for making the comment to be interpreted by the tool

* `@Rest:`         is the token used for identify that the following operation must be imported as a REST method

* `method=`        it specifies which kind of method must be used for the REST importing

* `template=`      it specifies the template to be used for the given resource. It is worth noting that parameters must be specified within curl brackets as in the getOrders example in the demo folder.

Ex:
`/**! @Rest: method=get, template=/orders/{userId}?maxItems={maxItems}; */`

In this case the request type of the getOrders operation is like it follows:
<div class="code" src="rest_services_1.ol"></div>

The router automatically joins the parameters defined in the url {userId} and {maxItems} with the subnodes of the request message which have the same name. As an example the url:

`http://localhost:8080/DEMO/orders/homer?maxItems=10`

it will trigger the invocation of the target microservice on the getOrders operation with the following request message:
<div class="code" src="rest_services_2.ol"></div>


## output of the tool
As output the tool produces a file called router_import.ol which must be copied inside the folder router in order to be automatically loaded by the router when it is run. Indeed, once copied router_import.ol into the folder router, it is sufficient to launch

`jolie router.ol`

for enabling the router. It is worth noting that the microservice published as a REST service into the router must running too. The router indeed, just interprets the REST requests message and forward them to the final microservice
(which is the target microservice of the jolie2rest tool).

Options:
- enable_swagger [ default = true ]
This operation enables the creation of the related json swagger file which can be easily imported into Swagger (http://swagger.io/). Thanks to it, it is possible to invoke the rest apis from swagger.

- easy_interface [ default = false ]
This modality allows for skipping the usage of the router. It is useful when the microservice already provides a http port where its operations are available. In such a case, the microservice is already able to receive json messages and reply with json messages. In these cases, only the swagger json file is created where all the operations are automatically converted into POST calls. No annotations and templates are required in these cases.
WARNING: the http protocol of the microservice must define the follwing parameters:
<div class="code" src="rest_services_3.ol"></div>

## Running the example
Pre-requisite:
Prepare a web application for running a local instance of a Swagger UI (http://swagger.io/swagger-ui/). If you want to use jolie, you could download Leonardo web server (https://github.com/jolie/leonardo) and put the content of the SwaggerUI inside the folder www.
Then launch `jolie leonardo.ol` in a separate shell and get the index.html page from your browser.

The example:
Go into folder tools and launch the following command:

`jolie jolie2rest.ol localhost:8080 swagger_enable=true easy_interface=false`

Copy the file `router_import.ol` into folder router.
Copy the filw swagger_DEMO.json in the folder where your SwaggerUI application can retrieve it. If you are using Leonardo just put it inside folder www.
Go into the folder tools/demo and launch the demo microservice:

`jolie demo.ol`

Open a new shell, go into the router folder and launch the router:

`jolie router.ol`

Open the SwaggerUI application with your browser and put the URL for retrieving the file swagger_DEMO.json inside the explorer text field . If you are using Leonardo put `http://localhost:XXXX/swagger_DEMO.json`, where XXXX is the port you chose for Leonardo.

Try to call your REST jolie service using the SwaggerUI.


## tools/jolie_stubs_from_swagger
This tool allows for the creation of a jolie client for each path declared in a Swagger definition.
Usage:
`jolie jolie_stubs_from_swagger.ol url service_name output_folder`

where:
- url is the url where the swagger definition can be retrieved
- service_name is the name of the service represented by the swagger definition
- output_folder is the name of the folder where all the files will be created

Example:
`jolie jolie_stubs_from_swagger.ol http://petstore.swagger.io/v2/swagger.json petstore petstore`

Once executed the following files will be created in the output_folder:
- outputPort.iol
- list of all the clients (name_of_the_operation).ol

outputPort.iol contains the interface and the outputPort definition of the service described by the swagger definition.
Such a file must be included in each microservice which aims at invoking the service described by the swagger definition.

In the example described above in the folder petstore it is possible to find the getOrderById.ol file.
Try to open it and set the request message as:
<div class="code" src="rest_services_4.ol"></div>

Then run the command
`jolie getOrderById.ol`

and look at the reply printed out in the console.

NOTE:
Only application/json APIs are enabled so far
