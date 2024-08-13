#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
 #Display a list of services

  echo -e "Welcome to My Salon, how can I help you?\n"
  #If we don't offer the service requested
  if [[ $1 ]]
  then

  echo $1

  fi

  echo -e "1) cut \n2) color \n3) perm \n4) style \n5) trim"
 #Ask user for service

read SERVICE_ID_SELECTED 
#Try to find if the we offer the service
case $SERVICE_ID_SELECTED in
            1) BOOKING ;;
            2) BOOKING ;;
            3) BOOKING ;;
            4) BOOKING ;;
            5) BOOKING ;;
            *) MAIN_MENU "I could not find that service. What would you like today?";;
esac

}
#Booking an appointment
BOOKING() {
  SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  echo $SERVICE_NAME
  #Trying to book an appointment
  #Ask for user phone number

  echo "What's your phone number?"
  read CUSTOMER_PHONE
  
  #Check if the user is an existing customer or not
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  echo $CUSTOMER_ID
  #if not. Ask for their name
  if [[ -z $CUSTOMER_ID ]]
    then

    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    
    #Add their details to the customer table
    INSERT_INTO_CUSTOMER=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")

  fi
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  #Ask for the time of appointment
  echo What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?
  read SERVICE_TIME

  #Add their details to the appointments table
  INSERT_INTO_APPOINTMENT=$($PSQL "insert into appointments(customer_id,time,service_id) values($CUSTOMER_ID , '$SERVICE_TIME' , $SERVICE_ID_SELECTED)" )
  if [[ $INSERT_INTO_APPOINTMENT == 'INSERT 0 1' ]]
      then
        echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
MAIN_MENU