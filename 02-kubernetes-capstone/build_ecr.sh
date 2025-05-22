#!/bin/bash

set -e

ACCOUNT_ID="906328874067"
REGION="us-east-2"
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

API_REPO="capstone-api"
WEB_REPO="capstone-web"

V1_TAG="v1.0"
V2_TAG="v2.0"

echo "🔐 Logging in to Amazon ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REGISTRY

echo "📦 Ensuring ECR repositories exist..."

for repo in $API_REPO $WEB_REPO; do
  if aws ecr describe-repositories --repository-names $repo --region $REGION > /dev/null 2>&1; then
    echo "✅ ECR repository '$repo' exists."
  else
    echo "🚀 Creating ECR repository '$repo'..."
    aws ecr create-repository --repository-name $repo --region $REGION
  fi
done

# --- API Images ---
echo "🔧 Building and pushing $API_REPO $V1_TAG..."
docker build --platform=linux/amd64 -t $API_REPO:$V1_TAG ./events-api
docker tag $API_REPO:$V1_TAG $REGISTRY/$API_REPO:$V1_TAG
docker push $REGISTRY/$API_REPO:$V1_TAG

echo "🔧 Building and pushing $API_REPO $V2_TAG..."
docker build --platform=linux/amd64 -t $API_REPO:$V2_TAG ./events-api-v2
docker tag $API_REPO:$V2_TAG $REGISTRY/$API_REPO:$V2_TAG
docker push $REGISTRY/$API_REPO:$V2_TAG

# --- Website Images ---
echo "🔧 Building and pushing $WEB_REPO $V1_TAG..."
docker build --platform=linux/amd64 -t $WEB_REPO:$V1_TAG ./events-website
docker tag $WEB_REPO:$V1_TAG $REGISTRY/$WEB_REPO:$V1_TAG
docker push $REGISTRY/$WEB_REPO:$V1_TAG

echo "🔧 Building and pushing $WEB_REPO $V2_TAG..."
docker build --platform=linux/amd64 -t $WEB_REPO:$V2_TAG ./events-website-v2
docker tag $WEB_REPO:$V2_TAG $REGISTRY/$WEB_REPO:$V2_TAG
docker push $REGISTRY/$WEB_REPO:$V2_TAG

echo "✅ All images pushed to ECR: $REGISTRY"
