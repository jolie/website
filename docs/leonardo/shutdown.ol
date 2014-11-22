include "admin.iol"

outputPort Admin {
Location: "socket://localhost:9000/"
Protocol: sodep
Interfaces: AdminInterface
}

main
{
	shutdown@Admin()()
}

