package org;

import static jodd.jerry.Jerry.jerry;
import jodd.jerry.Jerry;
import jolie.runtime.JavaService;

import org.pegdown.Parser;
import org.pegdown.PegDownProcessor;

public class pegdownService extends JavaService{
	
	private static final PegDownProcessor proc = new PegDownProcessor( Parser.ABBREVIATIONS +
						Parser.AUTOLINKS + Parser.DEFINITIONS +
						Parser.HARDWRAPS + Parser.TABLES + 
						Parser.FENCED_CODE_BLOCKS +
						Parser.STRIKETHROUGH );
	
	public String markdownToHtml( String text ) {
		Jerry doc = jerry( proc.markdownToHtml( text ) );
    for( Jerry node: doc.$( "h1,h2,h3,h4,h5" ) ){
    	String id = node.text().toLowerCase()
    		.replaceAll("[^a-zA-Z0-9 -]" , "").replaceAll( " ", "-" );
			node.attr( "id", id );
    }
    return doc.html();
	}
	
}