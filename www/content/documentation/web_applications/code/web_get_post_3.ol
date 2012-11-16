execution { concurrent }

type SumRequest:void {
  .x:int
  .y:int
}

interface SumInterface {
  RequestResponse: 
    sum(SumRequest)(int), 
    form(void)(string)
}

inputPort MyInput {
  Location: "socket://localhost:8000/"
  Protocol: http { .format = "html" }
  Interfaces: SumInterface
}

main
{
  [ sum( request )( response ) {
    response = request.x + request.y
  }]{ nullProcess }

  [ form()( f ) {
    f = "
      &lt;html&gt;
        &lt;body&gt;
          &lt;form action='sum' method='POST'&gt;
            &lt;code&gt;x&lt;/code&gt;: &lt;input type='text' value='3' name='x' /&gt;
            &lt;br/&gt;
            &lt;code&gt;y&lt;/code&gt;: &lt;input type='text' value='2' name='y' /&gt;
            &lt;br/&gt;
            &lt;input type='submit'/&gt;
          &lt;/form&gt;
        &lt;/body&gt;
      &lt;/html&gt;"
  }]{ nullProcess }
}