include "twiceInterface.iol"

inputPort TwiceService {
  Location: "socket://localhost:8000"
  Protocol: sodep
  Interfaces: TwiceInterface
}