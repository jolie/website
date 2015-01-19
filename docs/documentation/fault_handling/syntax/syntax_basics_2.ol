scope( scope_name )
{
	install ( 	fault_name1 => /* fault handling code */,
				/* ... */ 	=> /* fault handling code */,
				fault_nameN => /* fault handling code */
	);
	
	// omitted code
	throw( fault_name )
}