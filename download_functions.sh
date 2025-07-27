#!/bin/bash

cd sam-tva-experience/functions

# List of all Lambda functions
FUNCTIONS=(
    "tva-experience-dev2-login:login"
    "tva-experience-dev2-loginEmail:loginEmail"
    "tva-experience-dev2-verifyToken:verifyToken"
    "tva-experience-dev2-registerEmail:registerEmail"
    "tva-experience-dev2-sendEmail:sendEmail"
    "tva-experience-dev2-recoveryPassword:recoveryPassword"
    "tva-experience-dev2-verifyAccount:verifyAccount"
    "tva-experience-dev2-resendCode:resendCode"
    "tva-experience-dev2-changePassword:changePassword"
    "tva-experience-dev2-verifySession:verifySession"
    "tva-experience-dev2-verifyProvider:verifyProvider"
    "tva-experience-dev2-facebookLikes:facebookLikes"
    "tva-experience-dev2-historyChannel:historyChannel"
    "tva-experience-dev2-loginAnonymous:loginAnonymous"
    "tva-experience-dev2-addTransitionToken:addTransitionToken"
    "tva-experience-dev2-verifyTransitionToken:verifyTransitionToken"
)

echo "Downloading Lambda function codes..."

for func in "${FUNCTIONS[@]}"; do
    IFS=':' read -r function_name folder_name <<< "$func"
    
    echo "Processing $function_name -> $folder_name"
    
    # Skip if already exists
    if [ -d "$folder_name" ]; then
        echo "  Directory $folder_name already exists, skipping..."
        continue
    fi
    
    # Create directory
    mkdir -p "$folder_name"
    cd "$folder_name"
    
    # Get function details and download URL
    echo "  Getting function details..."
    DOWNLOAD_URL=$(aws lambda get-function \
        --function-name "$function_name" \
        --region us-east-1 \
        --query 'Code.Location' \
        --output text)
    
    if [ "$DOWNLOAD_URL" != "None" ] && [ ! -z "$DOWNLOAD_URL" ]; then
        echo "  Downloading function code..."
        curl -s -o function.zip "$DOWNLOAD_URL"
        
        if [ $? -eq 0 ]; then
            echo "  Extracting code..."
            unzip -q function.zip
            rm function.zip
            echo "  ✓ Successfully downloaded $function_name"
        else
            echo "  ✗ Failed to download $function_name"
        fi
    else
        echo "  ✗ No download URL available for $function_name"
    fi
    
    cd ..
done

echo ""
echo "Download completed! Function structure:"
ls -la
