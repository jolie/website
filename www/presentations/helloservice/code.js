
function jolieCall( operation, request, callback ) {    
    $.ajax({
	  url: '/' + operation,
	  dataType: 'json',
	  data: JSON.stringify( request ),
	  type: 'POST',
	  contentType: 'application/json',
	  success: function( data ) { callback( data ) }
    })
}
