## SODEP Protocol

SODEP (Simple Operation Data Exchange Protocol) is a binary protocol created and developed for Jolie, in order to provide a simple, safe and efficient protocol for service communications.

Protocol name in port definition: `sodep`.

---

## SODEP Parameters

<div class="code" src="sodep.iol"></div>

---

## SODEP data

SODEP maps three Jolie internal data structures: `CommMessage?`, `FaultException?`, and `Value`.

Basically, a SODEP message is the encoding of a `CommMessage?` object.

For the sake of clarity, we show (in Java pseudo-code) how these structures are composed and the meaning of their content before giving the formal specifications of the protocol.

#### CommMessage

- `long` `id`: a unique identifier for this message, generated from the requester;
- `String` `resourcePath`: the resource path this message should be delivered to. If the message is meant to be received from the service you are communicating with, the resource path should be "/";
- `String` `operationName`: the operation name this message refers to;
- `FaultException?` `fault`: the fault exception this message contains, if any;
- `Value` `value`: the data this message contains, if any.

#### FaultException

- `String` `faultName`: the fault name this FaultException? refers to;
- `Value` `value`: the data regarding this fault, if any.

#### Value

- `Object` `content`: the content of this value. Can be a String, an Integer, or a Double; 
- `Map< String, Value[] >` ``: the children vectors of this value, mapped by name.

---

### Formal specification

We represent the protocol encoding by using a BNF-like notation. Raw data types are supplied with additional information in round parentheses, in order to indicate what they represent.

- `true` and `false` are the respective boolean values;
- `null` is the Java *null* value;
- `int` is a 32-bit integer value;
- `long` is a 64-bit integer value;
- `double` is a 64-bit double value;
- `String` elements are to be intended as standard UTF-8 encoded strings;
- `*` is to be intended as the Kleene star (zero or more repetition);
- raw numbers annotated with `byte` are to be considered single bytes;
- the special keyword epsilon means *nothing*.

SODEPMessage	::= long(message id) String(resource path) String(operation name) Fault Value

String	 ::= int(string length) string(UTF-8 encoded)

Fault	 ::= true String(fault name) Value(fault additional data) | false

Value	 ::= ValueContent int(how many ValueChildren) ValueChildren*

ValueContent	::= 0(byte) | 1(byte) String | 2(byte) int | 3(byte) double | 4(byte) byte array | 5(byte) bool | 6(byte) long

ValueChildren	::= String(child name) int(how many Value) Value* | epsilon
