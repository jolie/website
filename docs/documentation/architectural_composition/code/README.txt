Try to run more than one client by setting the ClientLocation in command line as in the following:

jolie -C ClientLocationConstant=\"socket://localhost:4001\" Client.ol

This line runs a client located at port 4001.
Try to open three shells and run three different clients:
jolie -C ClientLocationConstant=\"socket://localhost:4001\" Client.ol
jolie -C ClientLocationConstant=\"socket://localhost:4002\" Client.ol
jolie -C ClientLocationConstant=\"socket://localhost:4003\" Client.ol
