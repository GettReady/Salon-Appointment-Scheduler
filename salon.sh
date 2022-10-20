#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SHOW_SERVICES_LIST() {
  echo -e "\nYou can select any of the provided services:"
  LIST_OF_SERVICES=$($PSQL "select service_id, name from services")  
  echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
}

GET_SERVICE_ID() {
  SHOW_SERVICES_LIST
  read SERVICE_ID_SELECTED
  SERVICE_CHECK=$($PSQL "select * from services where service_id=$SERVICE_ID_SELECTED")
}

GET_SERVICE_ID
while [[ -z $SERVICE_CHECK ]]
do
  GET_SERVICE_ID
done

echo -e "Please enter your phone number:"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "Please enter your name:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
echo -e "Enter preferable time:"
read SERVICE_TIME
INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
