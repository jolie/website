include "console.iol"
include "time.iol"
include "ini_utils.iol"
include "file.iol"
include "string_utils.iol"

include "SlideShareInterface.iol"

execution { concurrent }

type GenerateSHA1Request: void {
	.secret: string
}

type GenerateSHA1Response: void {
	.sha1: string
}

interface SlideShareSHA1GeneratorInterface {
RequestResponse:
	generateSHA1( GenerateSHA1Request )( GenerateSHA1Response )
}

outputPort SlideShare {
Location: "socket://www.slideshare.net:443/api/2/"
Protocol: https { .ssl.protocol = "TLSv1"; .method="get"; .compression = false }
RequestResponse:
	get_slideshows_by_user
}

outputPort SlideShareSHA1Generator {
Interfaces: SlideShareSHA1GeneratorInterface
}

embedded {
Java:
	"org.jolie.lang.slideshare.SlideShareSHA1Generator" in SlideShareSHA1Generator
}

inputPort SlideShare {
Location: "local"
Protocol: sodep
Interfaces: SlideShareInterface
}

init {
      global.slidesharets = 0;
      global.response = "";
	parseIniFile@IniUtils( "/config/config.ini" )( config );
	APIKEY = config.SlideShare.APIKEY;
	SHAREDSECRET = config.SlideShare.SHAREDSECRET
}

main {
	get_slideshows_by_user( request )( response ) {
	    getCurrentTimeMillis@Time()( ts );
	    if ( (ts - global.slidesharets) > 3600000 ) {
		    global.slidesharets = ts;
		    ts = int( ts / 1000 );
		    r.secret = SHAREDSECRET + ts;
		    generateSHA1@SlideShareSHA1Generator( r )( result );

		    with( request ) {
			    .api_key = APIKEY;
			    .ts = string( ts );
			    .hash = result.sha1;
			    .username_for = request.username_for
		    };
		    scope( slidesh ) {
			    install( default => nullProcess );
			    get_slideshows_by_user@SlideShare( request )( global.response )
		    }
	    };
	    response -> global.response
      }

}
