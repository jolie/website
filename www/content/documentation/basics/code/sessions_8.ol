// server.iol
include "chat.iol"
include "console.iol"
include "security_utils.iol"

execution { concurrent }

cset { 
	name: 	CreateRoomRequest.name
			SendMessage.roomName 
}

cset { 
	adminToken: CloseRoomMessage.adminToken 
}

inputPort ChatInput {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: ChatInterface
}

main {
	create( createRoomRequest )( csets.adminToken ) {
		csets.adminToken = new
	}; run = 1;
	while( run ) {
		[ publish( message ) ] {
			println@Console( "[" + csets.name + "]: " + message.content )()
		}
		[ close( closeMessage ) ] {
			run = 0;
			println@Console(	"Chat room " + csets.name + 
								" closed. Reason: " + closeMessage.reason )()
		}
	}
}