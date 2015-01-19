include "regInterface.iol"

inputPort Register {
	Location: "socket://localhost:2000"
	Protocol: sodep
	Interfaces: RegInterface
}

execution { concurrent }

init 
{	
	global.registered_users=0;
	response.message = "Successful registration.\nYou are the user number "
}

main 
{
	register()( response ){
		synchronized( syncToken ) {
			response.message = response.message + ++global.registered_users
		}
	}
}