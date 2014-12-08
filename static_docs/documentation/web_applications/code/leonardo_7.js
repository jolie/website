$( document ).ready( function() {
  	$( "#lengthButton" ).click( function() {
      Jolie.call(
      	 'length',
      	 { item: [
            $("#text1").val(),
            $("#text2").val(),
            $("#text3").val()
          ] 
        },
        function( response ) {
        	 $( "#result" ).html( response );
      	 }
    	 );
  	})
});