/* global $:false, window:false, document:false, alert:false, 
SyntaxHighlighter:false */
"use strict";

// css components in HTML

var css_menu	= "#js_menu";
var css_content = "#js_content";
var css_header	= "#js_header";
var css_site_header = "#js_site_header";

// constants

var adjThs = 10;

// paths to files
var root = "documentation/";
var docs_code_folder = "code/";
var docs_syntax_folder = "syntax/";
var files_menu = root + "menu.json";

// counter and logic for syntax highlighting
var shc = 0;
var syntH = {
	get: function () { shc += 1; },
	put: function () { shc -= 1; if( shc === 0 ){ syntH.run(); } },
	run: function () { SyntaxHighlighter.highlight(); }
};
SyntaxHighlighter.defaults.toolbar = false;
SyntaxHighlighter.defaults["auto-links"] = false;

// LAYOUT

// resizes containers to the height of the browser's window
var resizeHeight = function () {
	var window_height = $( window ).height();
	$( css_content ).height( window_height - 
		$( css_header ).outerHeight() - adjThs );
	$( css_menu ).height( window_height - 
		$( css_site_header ).outerHeight() - adjThs );
};

var loadFunctions = function (){
	resizeHeight();
	$( window ).resize( resizeHeight );

	loadMenu();
	loadPage();

};

// DOCUMENTS LOGIC

var loadPage = function(){

}

var loadMenu = function() {
	$.getJSON( files_menu, function(json, textStatus) {
			var menu = createMenu( json );
			$( css_menu ).html( menu );
	});
};

var createMenu = function ( json ) {
	var ul = $( "<ul></ul>" );
	$( json ).each( function( i, el ) {
		createMenuItem( ul, el );
	});
	return ul;
};

var createMenuItem = function ( ul, el ) {
	$( el ).each( function ( i, e ) {
		var li = $( "<li></li>" );
		li.html( $( "<span></span>").text( e.label ) );
		createItems( li, e.children );
		ul.append( li );
	});
};

var createItems = function ( el, children ){
	var ul = $( "<ul></ul>" );
	$( children ).each( function( i, e ) {
		var li = $( "<li></li>" );
		var a = $( "<a></a>" ).attr( "href", e.url );
		// every link returns itself to loadMenuItem
		a.attr( "onclick", "return loadMenuItem( event );" );
		a.text( e.label );
		$( li ).append( a );
		$( ul ).append( li );
	});
	$( el ).append( ul );
};

var loadMenuItem = function( event ){
	$( css_menu ).find( ".menu_selected" ).each( function(i, e) {
		$( e ).attr( "class", "" );
	});
	var el = $( event.target );
	el.attr( "class" , "menu_selected" );
	var par = $( el ).parent().parent();
	while( par.prop( "tagName" ).toLowerCase() != "li" ){
		par = par.parent();
	}
	updateBreadcrumb( el, par );
	var href = el.attr( "href" );
	var doc = root + href;
	$.get( doc, function( data ) {
		$( css_content ).html( data );
		loadCode( href );
		loadSyntax( href );
		addTOCToParent( data, el );
		$( css_content ).scrollTop( 0 );
	});
	return false;
};

var addTOCToParent = function ( data, el ) {
	$( css_menu ).find( ".TOC" ).each( function( i, e ) {
		$( e ).remove();
	});
	var ul = $( "<ul></ul>" ).attr( "class", "TOC" );
	$( css_content ).find( "h2" ).each( function( i, e ) {
		ul.append( $( "<li></li>" )
			.append( $( "<a></a>")
				.attr( "href", "#" + $( e ).attr( "id" ) )
				.text( $( e ).text() ).click( function( event ) {
					$( css_menu ).find( ".toc_selected" ).each( function(i, e) {
						$( e ).attr( "class", "" );
					});
					var sube = $( event.target );
					sube.attr( "class" , "toc_selected" );
				}) ) );
	});
	el.parent().append( ul );
};

var loadCode = function ( href ) {
	var parent_folder = href.match(/(.+\/)/)[0];
	$( css_content ).find( ".code" ).each( function( i, el ) {
		syntH.get();
		var file = $( el ).attr( "src" );
		var path = root + parent_folder + docs_code_folder + file;
		$.get( path , function( data ) {
			$( el ).html( $( "<pre></pre>" )
				.attr("class", "brush: " + getLangFromExt( file ) )
				.text( data ) );
			syntH.put();
		}, "text");
	});
};

var loadSyntax = function ( href ) {
	var parent_folder = href.match(/(.+\/)/)[0];
	$( css_content ).find( ".syntax" ).each( function( i, el ) {
		// syntH.get();
		var file = $( el ).attr( "src" );
		var path = root + parent_folder + docs_syntax_folder + file;
		$.get( path , function( data ) {
			$( el ).html( $( "<pre></pre>" )
				// .attr("class", "brush: " + getLangFromExt( file ) )
				.text( data ) );
			// syntH.put();
		}, "text" );
	});
};

var getLangFromExt = function ( fileName ) {
	var ext = fileName.substring(fileName.lastIndexOf(".") + 1);
	if (extLang.ext[ext] && extLang.ext[ext].lang) {
	    return extLang.ext[ext].lang;
	} else {
	    return "jolie";
	}
};

var updateBreadcrumb = function ( el, parent ) {
	var bc = $( css_header ).find( ".breadcrumb ").html("");
	bc.append( $( "<li></li>" ).text( parent.find( "span" ).text() ) );
	bc.append( $( "<li></li>" ).text( el.text() ).attr( "class", "active" ) );
};

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

// Loaded on start
$( document ).ready( loadFunctions() );