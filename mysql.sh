#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE (){
    if [ $1 -eq 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2... $G SUCCESS $N"
    fi    
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root acces."
    exit 1 # manually exit if error comes
else
    echo "You are a super user"    
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MYSQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mySql Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySql Server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting up root password"
