$!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILURE"
        exit 1
    else
        echo "$2...SUCCESS"
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
VALIDATE $? "Installing MYSQL"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mySql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySql"


mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting root password"
