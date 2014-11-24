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
	if ( path == "/index.html" ) {
		$( ".page-content" ).attr( "class", "landing-page" );
		$( "#page-col" ).attr( "class", "" );
	}
};


// Loaded on start
$( document ).ready( function () {
	activeMenuItem();
	landingPage();
});