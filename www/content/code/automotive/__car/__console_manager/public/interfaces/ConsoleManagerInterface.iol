type SelectRequest: void {
  .msg: string
  .row*: void {
    .name: string
    .price: int
    .coord: string
    .location: string
  }
}


type SelectionFromDialogRequest: string {
  .token: string
}

interface ConsoleManagerInterface {
RequestResponse:
	/**!
	  it manages the selection procedure of the dialog box
	  @request: the list of the rows to be choosen
	  @response: the selected row number
	*/
	select( SelectRequest )( int )
OneWay:
	selectionFromDialog( SelectionFromDialogRequest ),
}