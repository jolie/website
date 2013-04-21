include "JpsrFrontend.iol"
include "../../account_manager/AccountManager.iol"

include "console.iol"
include "string_utils.iol"
include "smtp.iol"
include "file.iol"

execution { concurrent }

inputPort JpsrFrontendInput {
Location: "local"
Interfaces: JpsrFrontendInterface
}

cset {
	sid: ConfirmEmailType.sid
}

init
{
	install( SMTPFault => println@Console( main.SMTPFault.stackTrace )() );
	getServiceDirectory@File()( thisDir );
	wwwDir = thisDir + "/../www"
}

main
{
	[ requestUserCreation( request )( response ) {
		csets.sid = new;

		m.host = "smtpout.europe.secureserver.net";
		m.from = "donotreply@jolie-lang.org";
		m.authenticate.username = "donotreply@jolie-lang.org";
		m.authenticate.password = "XXX";
		m.to = request.username;
		m.subject = "Jolie Public Service Repository: Confirm your e-mail";
		m.content = "
			Thank you for creating an account for the Jolie Public Service Repository.
			Please click the following link to confirm your e-mail address.\n\n
			<a href=\"https://www.jolie-lang.org:8080/confirmEmail?sid=" + csets.sid + "\">
			https://www.jolie-lang.org:8080/confirmEmail?sid=" + csets.sid + "</a>"
		;
		m.contentType = "text/html";

		existsUser@AccountManager( request.username )( b );
		if ( b ) {
			f.filename = wwwDir + "/requestUserCreation_userExists.html";
			println@Console( m.content )()
		} else {
			f.filename = wwwDir + "/requestUserCreation_ok.html"//;
			//sendMail@SMTP( m )()
		};
		readFile@File( f )( response )
	} ] {
		confirmEmail( request )( response ) {
			scope( s ) {
				install( InvalidUsername => response = "NOT OK" );
				c.username = request.username;
				c.password = request.password;
				createUser@AccountManager( c )();
				response = "OK"
			}
		}
	}
}