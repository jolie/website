// HTTP GET input port
inputPort MyInput {
    //Location: ...
    Protocol: http
    //Interfaces: ...
}

// HTTP GET output port
outputPort MyOutput {
    //Location: ...
    Protocol: http { .method = "get" }
    //Interfaces: ...
}

// HTTP POST input port
inputPort MyInput {
  //Location: ...
  Protocol: http { .format = "html" }
  //Interfaces: ...
}

// HTTP POST output port
outputPort MyOutput {
    //Location: ...
    Protocol: http { .method = "post" }
    //Interfaces: ...
}