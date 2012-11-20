## Socket location

In Jolie a socket location identifies as a network socket. 

A socket location is an address expressed as a URI in the form `socket://domain:port`, where:

- `socket` defines the Jolie medium;
- `domain` identify the domain the resource belongs to. It can be either a domain name or an IP address;
- `port` defines the number used by a port.

Sockets can identify:

- Local socket address, used when the communication is directed to a program running on the same location of the sender, i.e., 

`socket://(localhost|127.0.0.1):port_number`;

- Remote socket address, used when the communication is directed to a program running on a remote location from the sender. In this case `host_name`s can be used in order to identify the resource via a Domain Name System, e.g., `www.google.com:80` and `173.194.71.147:80` point to the same location, i.e.,

`socket://(host_name|IP_address):port_number`.