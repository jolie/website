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
      <html>
        <body>
          <form action='sum' method='POST'>
            <code>x</code>: <input type='text' value='3' name='x' />
            <br/>
            <code>y</code>: <input type='text' value='2' name='y' />
            <br/>
            <input type='submit'/>
          </form>
        </body>
      </html>"
  }]{ nullProcess }
}