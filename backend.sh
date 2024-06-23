#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo "Enter DB password"
read mysql_password

# echo "Enter MySQL IP"
# read MySqlIP


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

mkdir -p /app &>>$LOGFILE # here by giving -p will create directory if no directory exist else just exit
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend code"

cd /app
rm -rf /app/* # this code will remove if any files already there
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracting backend code"


# cd /app

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"


cp /home/ec2-user/Expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Starting Backend services"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling Backend Services"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql client"

mysql -h 172.31.83.126 -uroot -p${mysql_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend services"
