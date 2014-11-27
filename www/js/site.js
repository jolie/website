/* global $:false, window:false, document:false, alert:false, 
SyntaxHighlighter:false */
"use strict";

var extLang = {
  "ext": {
    "xml": { "lang": "xml" },
    "html": { "lang": "xml" },
    "json": { "lang": "jscript" },
    "js": {"lang": "jscript" },
    "ol": { "lang": "jolie" },
    "iol": { "lang": "jolie" },
    "java": { "lang": "java" },
    "txt": { "lang": "plain" }
  }
};

function activeMenuItem() {
    var path = window.location.pathname;
    $( "#header a.active" ).attr( "class", "");
    $( "#header a[href=\"" + path + "\"]" ).attr( "class", "active" );
};

function landingPage() {
	var path = window.location.pathname;
	if ( path == "/index.html" || path == "/" || path == "" ) {
		$( ".page-content" ).attr( "class", "landing-page" );
		$( "#page-col" ).attr( "class", "" );
	}
};

var bodyPadding = 0;

function scroll_to_section( section )
{
	$( "html,body" ).animate( {
	scrollTop:
		$("#" + section).offset().top
		// + $( "body" ).css( "padding-top" )
	}, 500 );
}

function bodyPadding()
{
	// $( "body" ).css( "padding-top", $( "#header" ).height() );
}

function setCloseClick( element ) {
	$( "#" + element + "button" ).html("[close]");	
	$( "#" + element + "button" ).unbind("click");	
	$( "#" + element + "button" ).click( function() {
		$( "#" + element ).css("box-shadow","0.6em 0.6em 0.6em #ddd");
		$( "#" + element ).css("border-radius","0 0 10em 0");
		$( "#" + element ).animate({height:"10em"},1200, function(){});
		$( "html,body" ).animate( {
		scrollTop:
			$("#" + element).parent().offset().top		
		}, 1000 );	
		setReadmoreClick( element );
	});
}

function setReadmoreClick( element ) {
	$( "#" + element + "button" ).unbind("click");
	$( "#" + element + "button" ).html("[...]");
	$( "#" + element + "button" ).click( function() {
	      $( "#" + element ).css("box-shadow","none");
	      $( "#" + element ).css("border-radius","none");
	      $( "#" + element ).animate({height:"100%"},2000, function(){});
	      setCloseClick( element );
	});
}

function readmore( element ) {
	$( "#" + element ).css("box-shadow","none");
	$( "#" + element ).animate({height:"100%"
	},2000, function(){});
	$( "#" + element + "button" ).removeAttr("onclick");
	setCloseClick( element );	
}

// Loaded on start
$( document ).ready( function () {
	activeMenuItem();
	landingPage();
	//bodyPadding();
});

