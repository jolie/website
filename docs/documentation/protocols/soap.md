## SOAP Protocol

SOAP (Simple Object Access Protocol) is a protocol for exchanging structured information among Web Services. It relies on XML for its message format.

Protocol name in port definition: `soap`.

---

## SOAP Transport

Our SOAP implementation does not support simple parameters and return values (signatures like `test( string )( int )`) to adhere to the WSDL specification. Please use compound types with root value `void` instead.

---

## SOAP Parameters

<div class="code" src="soap.iol"></div>
