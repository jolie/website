//server.ol

cset {
	sid: OpMessage.sid
}

main
{
	login( request )( response ){
		username = request.name;
		response.sid = csets.sid = new;
		// code 
	}
}