// fax.iol
type FaxRequest:void {
	.destination:string
	.content:string
}

interface FaxInterface {
OneWay:
	fax(FaxRequest)
}