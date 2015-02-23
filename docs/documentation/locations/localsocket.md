## Localsocket

Localsockets are Unix domain sockets, which are communication endpoints for exchanging data between processes executing within the same host operating system. The feature is limited to Unix-like OSs and not available on Windows.

The Jolie localsocket's port definition is `localsocket`. The implementation makes use of libmatthew-java which contains also a native (JNI) part not delivered within Jolie. It may be installed from the system's package repository (on Red Hat-like `yum install libmatthew-java`) or compiled manually. For running a localsockets program, the `libunix-java.so` library needs to be included in the system's ld cache (ldconfig) or specified by the `LD_LIBRARY_PATH` environment variable. This is a possible invocation: `LD_LIBRARY_PATH=/usr/lib64/libmatthew-java jolie program.ol`.</p>

---

## Localsockets locations

Localsockets locations can be regular or abstract. Abstract sockets are identical to the regular ones, except that their name does not exist in the file system. Hence, file permissions do not apply to them and when the file is not used any more, it is deleted, while the regular sockets persist.

- Abstract localsockets definition: `localsocket://abs/path/to/socket`
- Regular localsockets definition: `localsocket:///path/to/socket`
