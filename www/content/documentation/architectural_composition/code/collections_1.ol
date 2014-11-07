// printer.iol
type PrintRequest:void {
    .job:int
    .content:string
}
 
interface PrinterInterface {
OneWay:
    print(PrintRequest), del(int)
}
 
// fax.iol
type FaxRequest:void {
    .destination:string
    .content:string
}
 
interface FaxInterface {
OneWay:
    fax(FaxRequest)
}