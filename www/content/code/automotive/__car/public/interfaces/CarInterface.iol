type CarFaultRequest: void {
  .fault: string
}


interface CarInterface  {
OneWay:
	carFault( CarFaultRequest )
}