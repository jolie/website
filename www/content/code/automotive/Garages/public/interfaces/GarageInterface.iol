type GarageBookRequest: void {
  .name:string
  .surname:string
  .car_model:string
  .plate: string
  .serviceType:string
  .bankLocation:string
}

type GarageBookResponse: void {
  .reservationId:string
  .transactionId: string
  .bankLocation:string
  .amount:int
}

type GetGaragePriceRequest: void {
  .serviceType: string
}

type GetGaragePriceResponse: void {
  .price: int
}

type GarageRevBookRequest: void {
  .reservationId: string
}


interface GarageInterface {
RequestResponse:
  garageBook( GarageBookRequest )( GarageBookResponse )
    throws GarageBookFault,

  getGaragePrice( GetGaragePriceRequest )( GetGaragePriceResponse )

OneWay:
  garageRevbook( GarageRevBookRequest )
}