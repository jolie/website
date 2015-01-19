## Jolie Locations

A location defines the medium on which a port sends and receive messages.

A location is always a URI in the form `medium[:parameters]`, where `medium` is the medium identifier and the optional `parameters` is a medium-specific string

Jolie natively supports four media:

- `socket` (TCP/IP sockets);
- `btl2cap` (Bluetooth L2CAP);
- `rmi` (Java RMI);
- `localsocket` (Unix local sockets).

In addition, when embedding a service, Jolie supports the `local` medium, which exploits system's memory to send and receive messages.

An example of a valid location is: `socket://www.mysite.com:80/`, where `socket` is the `medium` and the following part represents the `parameters`.

In this section we explain the medium-specific properties of the locations provided by Jolie.