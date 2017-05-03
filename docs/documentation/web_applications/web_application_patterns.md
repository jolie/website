## Web Application Patterns

This page collects generic patterns and staple elements used in web applications, like handling [HTML querystring requests](#!documentation/web_applications/web_application_patterns.html#HTML_querystrings) and [HTML forms](#!documentation/web_applications/web_application_patterns.html#HTML_forms) as well as examples on how to read and manipulate [cookies](#!documentation/web_applications/web_application_patterns.html#using_cookies), [HTML headers](#!documentation/web_applications/web_application_patterns.html#HTML_headers). 

This page does not contain material directly related to RESTful implementations, which is presented in detail in the [Rest Services](#!documentation/rest_services/rest_services.html) page.


---

## HTML Querystrings



---

## HTML Forms


---

## Using Cookies

Jolie HTTP protocol is able to handle cookies both when processing outbound and inbound HTTP messages. Jolie allows to define specific cookies handling at port level without the need of writing further processing code. 

### Operation-related Inbound Cookie Handling

In a traditional client/server web application the programmer may need to define specific pieces of data to store stateful information. Cookies were designed to implement such mechanism. The HTTP protocol in Jolie makes easy to binding inbound/outbound cookies to a specific path within an operation's message sub-node. To do so is sufficient to define in the configuration of the protocol the parameter

`.osc.operationName.cookies.cookieName = "subNodeName"`

which means that the node `subNodeName` within the message of operation `operationName` is bound to a cookie called `cookieName`. For inputPorts this binding takes a cookie called `cookieName` in the request and stores its content inside the sub-node `.subNodeName` in the message passed to operation `operationName`. Similarly, for outputPorts the binding goes from the data inside the sub-node `.subNodeName` to the value associated to cookie `cookieName` in the outbound message. 

Below, a working example on how to handle inbound cookies (it uses the [Leonardo](#!documentation/web_applications/leonardo.html) Jolie web server as reference web application).

<div class="download"><a href="documentation/web_applications/code/cookie_server_code.zip">Inbound cookie handling example</a></div>

The example contains the code for both the client side (HTML/JQuery) and server side (Jolie) that handles two distinct cookies. In order to understand the example specific attention should be paid to the following files:

* `/doc/TestingInstruction.txt`;
* `/doc/ExampleAbstract.txt`;
* `/www/js/CookiesHandler.js`;
* `/leornardo.ol`.

It is not necessary to define precisely the cookie binding for each operation exposed by the HTTP input port, one can use the global cookies configuration expressed in the following form  `.cookies.cookieName = "subNodeName"`, Particular attention must be paid on the presence of `.subNodeName` in the type of all operation exposed by the port otherwise a `TypeMismatch` will occur.