foreach ( kind : animals ){

  for ( animal in animals.( kind ) ){
    println@Console( animal.name )()
  }

}