This is the automotive scenario demo.
It is a SOA composed of more than 17 distributed services.

In order to test it, it is necessary to launch all the services.

Follow the next steps in order to turn on the automotive SOA.
Please start a new shell for each of the follwing jolie commands.

#REGISTER
cd ./__register
jolie main_register.ol

#ASSISTANCE SERVICE
cd ./__assistance
jolie leonardo.ol

#BANK SYSTEM
cd ./__bank_system
jolie main_bankAE.ol
jolie main_bankVISA.ol

cd ./__bank_system/__bank_account
jolie main_bank_account_AE.ol
jolie main_bank_account_VISA.ol

#GARAGES SERVICES
cd ./__garages
jolie main_garage1.ol
jolie main_garage2.ol
jolie main_garage3.ol
jolie aggregator.ol

#RENTAL SERVICES
cd ./__rental
jolie main_rental1.ol
jolie main_rental2.ol
jolie main_rental3.ol

#TRUCK SERVICES
cd ./__truck
jolie main_truck1.ol
jolie main_truck2.ol
jolie main_truck3.ol

NOTE:
a) bank account databases are implemented with derby embedded, if you need to restore them:
  1) cd ./__bank_system/__bank_account/database
  2) rm * -R
  3) jolie install_db_AE.ol
  4) jolie install_db_VISA.ol

b) if you want to modify the credit amount of the car driver, follow these steps:
  1) cd ./__bank_system/__bank_account/script
  2) edit setAccount.ol and modify the credit as you like
  3) jolie setAccount.ol
  4) jolie getAccountAmount.ol // to verify the credit into the db

