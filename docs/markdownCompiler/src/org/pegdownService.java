package org;

import jolie.runtime.JavaService;
import org.pegdown.PegDownProcessor;

public class pegdownService extends JavaService{
	
	private static final PegDownProcessor proc = new PegDownProcessor();
	
	public String markdownToHtml( String text ){
				return proc.markdownToHtml( text );
	}
	
}
