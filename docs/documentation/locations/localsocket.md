## Localsocket

Localsocket are Unix domain sockets, which are communication endpoints for exchanging data between processes executing within the same host operating system.

The localsocket's in Jolie port definition is `localsocket`.

---

## Localsockets locations

Localsockets locations can be regular or abstract. Abstract sockets are identical to the regular ones, except that their name does not exist in the file system. Hence, file permissions do not apply to them and when the file is not used any more, it is deleted, while the regular sockets persist.

- Abstrat localsockets definition: `localsocket:abs:/path/to/socket`
- Regular localsockets definition: `localsocket:/path/to/socket`