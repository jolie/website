include "console.iol"
include "string_utils.iol"
include "ini_utils.iol"
include "file.iol"
include "SocialInterface.iol"

execution{ concurrent }

type GetSignature4StatusRequest: void {
	.consumerKey: string
	.consumerSecret: string
	.tokenSecret: string
	.accessToken: string
	.status: string
}

type GetSignature4StatusResponse: string {
	.ts: string
	.nonce: string
}

interface TwitterUtilsInterface {
RequestResponse:
      getSignature4Status( GetSignature4StatusRequest )( GetSignature4StatusResponse )
}



outputPort TwitterUtils {
Interfaces: TwitterUtilsInterface
}

embedded {
Java:
      "org.jolie.twitter.TwitterUtils" in TwitterUtils
}

outputPort Twitter {
Location: "socket://api.twitter.com:443/1.1/statuses/update."
Protocol: https { .ssl.protocol = "TLSv1"; .format="x-www-form-urlencoded"; .method="POST";  .addHeader -> addHeader; .compression = false }
RequestResponse:
      json
}

inputPort Social {
Location: "local"
Protocol: sodep
Interfaces: SocialInterface
}

init {
	parseIniFile@IniUtils( "/config/config.ini" )( config );
	consumerKey = config.Twitter.consumerKey;
	consumerSecret = config.Twitter.consumerSecret;
	tokenSecret = config.Twitter.tokenSecret;
	accessToken = config.Twitter.accessToken;
	twitterFeature = is_defined( config.Twitter );
	if ( !twitterFeature ) {
		println@Console( "Twitter post feature deactivated (configuration missing)" )()
	}
}

main {
      [ postOnTwitter( request )( response ) {
	    scope( post ) {
		    install( default => valueToPrettyString@StringUtils( post.( post.default ) )( s );
					println@Console( post.default + ":" + s )();
					throw( TwitterError )
		    );
				if ( !twitterFeature ) {
					throw( TwitterError, "Twitter post feature is deactivated" )
				};
		    with( r ) {
			      .consumerKey = consumerKey;
			      .consumerSecret = consumerSecret;
			      .tokenSecret = tokenSecret;
			      .accessToken = accessToken;
			      /*split_rs = request.status;
			      split_rs.length = 140;
			      splitByLength@StringUtils( split_rs )( split_res );*/
			      .status = request.status
		    };
		    getSignature4Status@TwitterUtils( r )( sig );
		    addHeader.header = "Authorization";
		    addHeader.header.value = "OAuth oauth_consumer_key=\"" + consumerKey
				      + "\", oauth_nonce=\"" + sig.nonce
				      + "\", oauth_signature=\"" + sig
				      + "\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"" + sig.ts
				      + "\", oauth_token=\"" + accessToken
				      + "\", oauth_version=\"1.0\"";
		    twitter_req.status = r.status;
		    //valueToPrettyString@StringUtils( sig )( s );println@Console( s )();
		    json@Twitter( twitter_req )( twitter_res )
		    //valueToPrettyString@StringUtils( twitter_res )( s );println@Console( s )()
	    }
      }] { nullProcess }
}
