// chat.iol

type CreateRoomRequest:void {
	.name:string
	.description:string
}

type CloseRoomMessage:void {
	.adminToken:string
	.reason:string
}

type SendMessage:void {
	.roomName:string
	.content:string
}

interface ChatInterface {
OneWay: publish(SendMessage), 
		close(CloseRoomMessage)
RequestResponse: create(CreateRoomRequest)(string)	
}