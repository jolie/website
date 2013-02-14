//client.ol

main
{
	login@PrintService( request )( response );
	opMessage.sid = response.sid;
	// if user wants to print
		opMessage.message="my Message";
		print@PrintService( opMessage );
	// else he wants to logout
		logout@PrintService( opMessage )
}