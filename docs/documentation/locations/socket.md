## Socket

In Jolie a socket location defines a TCP/IP network socket. 

Socket location name in Jolie port definition is `socket`.

A socket location is an address expressed as a URI in the form `socket://host:port/path`, where:

- `host` identifies the system running the Jolie program. It can be either a domain name or an IP address;
- `port` defines the port on which the communication takes place.

The couple `host:port` represents an *authority*, where:

- `path` contains the path that identifies the Jolie program in the scope of an *authority*.

### Local and remote socket locations

Sockets can identify:

- Local socket address, used when the communication is directed to a program running on the same location of the sender, i.e., <br> `socket://(localhost|127.0.0.1):port_number/path`;

- Remote socket address, used when the communication is directed to a program running on a remote location from the sender. In this case `host_name`s can be used in order to identify the resource via a Domain Name System, e.g., `www.google.com:80` and `173.194.71.147:80` point to the same location, i.e., <br> `socket://(host_name|IP_address):port_number/path`.