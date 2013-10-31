// inteface.ol

type LoginType: void {
	.name: string
}

type SubscriptionType: void {
	.channel: int
	.sid: string
}

type MessageType: void {
	.message: string
	.sid: string
}

type LogType: void {
	.sid: string
}

interface ChatInterface {
	RequestResponse: 
		login( LoginType )( LogType )
	OneWay: 
		subscribe( SubscriptionType ), 
		sendMessage( MessageType ), 
		logout( LogType )
}

// server.ol

cset {
	sid: SubscriptionType.sid
		 MessageType.sid
		 LogType.sid
}