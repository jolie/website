scope( scope_name )
{
	install ( 
		Error1 => // fault handling code,
		...
		ErrorN => // fault handling code
	);
	
	// omitted code
	
	throw( fault_name )
}