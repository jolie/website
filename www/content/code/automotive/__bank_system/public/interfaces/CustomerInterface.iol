type BankCommitRequest: void {
  .transactionId: string
  .reservationId: string
  .result: bool
}

interface CustomerInterface {
OneWay:
  bankCommit( BankCommitRequest )
}