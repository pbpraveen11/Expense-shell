#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Enter MySQL IP"
read sqlIp


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi    
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root acces."
    exit 1 # manually exit if error comes
else
    echo "You are a super user"    
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling jodejs:20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "Creating Expense user"
else
    echo -e "Expense user Already created...$Y SKIPPING $N"
fi


# mkdir /app

# curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

# cd /app

# unzip /tmp/backend.zip

# cd /app

# npm install

# vim /etc/systemd/system/backend.service

# systemctl daemon-reload

# systemctl start backend

# systemctl enable backend

# dnf install mysql -y

# mysql -h sqlIp -uroot -pExpenseApp@1 < /app/schema/backend.sql

# systemctl restart backend