#!/usr/bin/bash
set +x

sudo apt install -y unzip

cd
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

region="us-east-1"

IFS=, && read keyid key <<< `tail -n 1 $1`

# AWS creds can be set as env variables
#export AWS_ACCESS_KEY_ID=$key
#export AWS_SECRET_ACCESS_KEY=$keyid
#export AWS_DEFAULT_REGION=$region

aws configure set aws_access_key_id $keyid
aws configure set aws_secret_access_key $key
aws configure set default.region $region

if [ $? -eq 0 ] 
    then
        echo "aws login successful"
    else
        echo "aws login failed"
fi

