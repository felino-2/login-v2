#!/bin/bash

API_ID="f2hrjgpiik"
REGION="us-east-1"

# Get all resources with methods
RESOURCES=$(aws apigateway get-resources --rest-api-id $API_ID --region $REGION --query 'items[?resourceMethods].[id,path,resourceMethods]' --output json)

echo "Extracting Lambda functions from API Gateway..."

# Resource IDs and their paths that have POST methods
RESOURCE_IDS=(
    "qxgdlf:/login"
    "xxtxzp:/email/login" 
    "nsretg:/verifytoken"
    "5kgaeu:/email/register"
    "ii7ou2:/email/send"
    "uippgt:/email/recovery"
    "ujz4jc:/email/verifyaccount"
    "rmspvq:/email/resendcode"
    "3jl1l6:/email/resetaccount"
    "lz3t82:/verify/session"
    "g8etrg:/verifyprovider"
    "wfnkcg:/facebooklikes"
    "2c1km7:/historychannel"
    "ltyrbo:/login/anonymous"
    "mt0mq9:/token/transition"
    "sj1o49:/verifytoken/transition"
)

echo "Found Lambda functions:"
for resource in "${RESOURCE_IDS[@]}"; do
    IFS=':' read -r resource_id path <<< "$resource"
    echo "Checking $path (Resource ID: $resource_id)"
    
    # Get method integration
    LAMBDA_URI=$(aws apigateway get-method \
        --rest-api-id $API_ID \
        --resource-id $resource_id \
        --http-method POST \
        --region $REGION \
        --query 'methodIntegration.uri' \
        --output text 2>/dev/null)
    
    if [[ $LAMBDA_URI == *"lambda"* ]]; then
        # Extract function name from URI
        FUNCTION_NAME=$(echo $LAMBDA_URI | sed 's/.*function://' | cut -d'/' -f1 | cut -d':' -f1)
        echo "  -> Lambda Function: $FUNCTION_NAME"
        echo "$FUNCTION_NAME" >> lambda_functions.txt
    fi
done

# Remove duplicates and sort
sort lambda_functions.txt | uniq > unique_lambda_functions.txt
echo ""
echo "Unique Lambda functions found:"
cat unique_lambda_functions.txt
