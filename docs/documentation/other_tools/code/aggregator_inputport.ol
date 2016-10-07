
outputPort Printer {
Location: "socket://localhost:9000"
Protocol: sodep
Interfaces: PrinterInterface
}

outputPort Fax {
Location: "socket://localhost:9001"
Protocol: sodep
Interfaces: FaxInterface
}

inputPort Aggregator {
Location: "socket://localhost:9002"
Protocol: sodep
Interfaces: AggregatorInterface
Aggregates: Printer, Fax
}
