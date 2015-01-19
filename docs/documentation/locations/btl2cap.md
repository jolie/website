## BTL2CAP

BTL2CAP is built upon the L2CAP (Logical Link Controller Adaptation Protocol) multiplexing layer and transmits data via the bluetooth medium.

BTL2CAP location name in Jolie is `btl2cap`. 

---

## BTL2CAP locations

The definition of a BTL2CAP location in Jolie is in the form `btl2cap://hostname:UUID[;param1=val1;...;paramN=valN]` where

- `hostname` identifies the host system running the Jolie program;
- `UUID` is the universally unique identifier that identifies the bluetooth medium service. UUIDs are 128-bit unsigned integers guaranteed to be unique across all time and space. In BTL2CAP location specification the UUID is defined by a 32 characters hexadecimal digit string, e.g., `3B9FA89520078C303355AAA694238F07`.
- `param1=val1` is a bluetooth-specific parameter assignation. For a comprehensive list of the parameters refer to the following list.

<div class="code" src="btl2cap.iol"></div>