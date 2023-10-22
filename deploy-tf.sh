#!/bin/bash -e

# Run this script during initial deployment
# To make/test changes, edit the resources/main.tf file and re-run this script

MSG=$1

# Return the aws account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Update the GitHub Actions workflows file
cp resources/terraform.yml .github/workflows/
sed -i "s/UPDATE_ME/$ACCOUNT_ID/g" .github/workflows/terraform.yml

# Return remote state bucket name
BUCKET_NAME=$(aws s3 ls | grep terraform-remote-state | cut -d " " -f 3)
printf "BUCKET_NAME = $BUCKET_NAME\n"

# Copy and add the bucket name to main.tf
cp resources/main.tf main.tf
sed -i "s/UPDATE_ME/$BUCKET_NAME/g" main.tf

# Execute pipeline via pushing changes to the main branch
git add .
git commit -m "$MSG"
git push