type GarageRevBookRequest:void{
	.reservationId[1,1]:string
	.garage_name: string
}

type GetGaragePriceRequest:void{
	.serviceType[1,1]:string
	.garage_name: string
}
type GetGaragePriceResponse:void{
	.price[1,1]:int
}
type GarageBookRequest:void{
	.garage_name: string
	.car_model[1,1]:string
	.name[1,1]:string
	.plate[1,1]:string
	.bankLocation[1,1]:string
	.surname[1,1]:string
	.serviceType[1,1]:string
}
type GarageBookResponse:void{
	.amount[1,1]:int
	.transactionId[1,1]:string
	.bankLocation[1,1]:string
	.reservationId[1,1]:string
}


interface GarageAggregatorSurface {
OneWay:
	garageRevbook( GarageRevBookRequest )
RequestResponse:
	shutdown( undefined )( undefined ),
	getGaragePrice( GetGaragePriceRequest )( GetGaragePriceResponse ),
	garageBook( GarageBookRequest )( GarageBookResponse ) throws GarageBookFault( undefined )
}

outputPort Garage {
	Location:"socket://localhost:3012"
	Protocol:sodep
	Interfaces:GarageAggregatorSurface
}
