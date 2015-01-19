## Invoking web services

Jolie can be used to invoke web services.

Let us exemplify it by invoking the Global Weather Service, provided by [www.webservicex.net](http://www.webservicex.net), whose [WSDL](http://www.w3.org/TR/wsdl) document can be accessed at the URL [http://www.webservicex.net/globalweather.asmx?WSDL](http://www.webservicex.net/globalweather.asmx?WSDL).

## Request the service interface from the WSDL

To invoke a web service's operation, we need to create a compatible Jolie interface. To do that we exploit the tool [wsdl2jolie](web_services/wsdl2jolie.html), which is part of the Jolie trunk installation.

We run the command:

`wsdl2jolie http://www.webservicex.net/globalweather.asmx?WSDL > myWS_jolieDocument.iol`

that extracts from the WSDL a compatible Jolie interface to invoke the web service. The newly created interface is stored in myWS_jolieDocument.iol file. 

Let us open the interface file and delete its first line, which is the comment `Retrieving document at 'http://www.webservicex.net/globalweather.asmx?WSDL'.`.

## Call the web service

Once we stored the Jolie interface of the web service, we can invoke its operations by including its interface definition file in a Jolie program:

<div class="code" src="web_services_2.ol"></div>

Since the web service returns a message formed by a single tag `<GetWeatherResult>`, which contains an XML document as a string, we have to exploit the `xml_utils.iol` library to transform the string into a Jolie value by means of the operation `xmlToValue`.

## Exposing web services

Jolie services can be exposed as web services as well.

Let us consider the following Jolie service which returns the address of a person identified by his name and his surname:

<div class="code" src="web_services_3.ol"></div>

To expose the port `MyServiceSOAPPort` as a web service, we exploit the tool [jolie2wsdl](web_services/jolie2wsdl.html) that generates the corresponding WSDL document to be attached to the file:

`jolie2wsdl -i /opt/jolie/include service.ol MyServiceSOAPPort MyWsdlDocument.wsdl`

Once generated the WSDL file is to be attached within the declaration of the inputPort:

<div class="code" src="web_services_4.ol"></div>