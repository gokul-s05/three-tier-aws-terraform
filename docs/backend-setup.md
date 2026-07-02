# Remote state backend setup

Terraform's S3 backend must exist before `terraform init` can use it. Create it manually once, using your own unique names.

## Commands

Set your variables:

    export STATE_BUCKET="your-unique-bucket-name"
    export LOCK_TABLE="your-lock-table-name"
    export AWS_REGION="ap-south-1"

Create the S3 bucket:

    aws s3api create-bucket \
      --bucket $STATE_BUCKET \
      --region $AWS_REGION \
      --create-bucket-configuration LocationConstraint=$AWS_REGION

Enable versioning:

    aws s3api put-bucket-versioning \
      --bucket $STATE_BUCKET \
      --versioning-configuration Status=Enabled

Enable encryption:

    aws s3api put-bucket-encryption \
      --bucket $STATE_BUCKET \
      --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

Block public access:

    aws s3api put-public-access-block \
      --bucket $STATE_BUCKET \
      --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

Create the DynamoDB lock table:

    aws dynamodb create-table \
      --table-name $LOCK_TABLE \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST \
      --region $AWS_REGION

## After creating these

Update `backend.tf` with your `$STATE_BUCKET` and `$LOCK_TABLE` values, then run `terraform init`.
