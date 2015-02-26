execution { concurrent }

type SumRequest:void {
  .param:void {
    .x:int
    .y:int
    .z:void {
      .a:int
      .b:int
    }
  }
}

type SumResponse:void {
  .param:int
}

interface SumInterface {
  RequestResponse: 
    sum(SumRequest)(SumResponse)
}

inputPort MyInput {
  Location: "socket://localhost:8000/"
  Protocol: xmlrpc { .debug = true }
  Interfaces: SumInterface
}

main
{
  [ sum( request )( response ) {
    response.param = request.param.x + request.param.y + request.param.z.a + request.param.z.b
  }]{ nullProcess }
}
