#!/bin/bash

echo "List of s3 bukcets"
aws s3 ls

echo "List of ec2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].Tags[].Value'

echo "List of lambda functions"
aws lambda list-functions

echo "List of IAM users"
aws iam list-users | jq '.Users[].UserName'
