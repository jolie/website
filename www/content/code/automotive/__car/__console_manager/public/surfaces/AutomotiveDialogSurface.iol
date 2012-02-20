type SelectionRequest: void {
  .msg: string
  .token: string
  .row*: void {
    .name: string
    .price: string
  }
}

outputPort Dialog {
Location: "local"
OneWay:
	/**!
	  select a row form a given list into the UI
	*/
	selection( SelectionRequest )
}

embedded {
	Java:
		"com.italianasoftware.automotive.AutomotiveDialog" in Dialog
}

