#!/bin/sh

echo "Create bucket for TF State Backend..."
awslocal s3 mb s3://terraform-state \
	--region eu-west-3

echo "Create DynamoDB Table for TF State Backend Locking..."
awslocal dynamodb create-table \
    --table-name terraform-state \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --tags Key=ManagedBy,Value=Terraform \
	--region eu-west-3

echo "Create Secret fot TF Datasources..."
awslocal secretsmanager create-secret \
    --name Test \
    --secret-string "{\"user\":\"gitpod\",\"password\":\"gitpod\"}" \
	--region eu-west-3