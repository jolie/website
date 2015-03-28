## SOAP Protocol

SOAP (Simple Object Access Protocol) is a protocol for exchanging structured information among Web Services. It relies on XML for its message format.

Protocol name in port definition: `soap`.

---

## SOAP Transport

To adhere to the WSDL specification, simple call signatures like `test( string )( int )` should be omitted. Input and output values should be passed by apposite compound structures with a `void` root value, as shown [here](web_services/web_services.html).

---

## SOAP Parameters

<div class="code" src="soap.iol"></div>
