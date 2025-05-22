#!/bin/bash

set -e

REGISTRY_NAMESPACE="default"
REGISTRY_NAME="registry"
REGISTRY_PORT="32000"
REGISTRY_ADDR="172.16.0.139:${REGISTRY_PORT}"

V1_TAG="v1.0"
V2_TAG="v2.0"

echo "🔧 Setting up in-cluster registry..."

# Step 1: Create registry namespace
kubectl create namespace $REGISTRY_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Step 2: Deploy registry in Kubernetes
kubectl apply -n $REGISTRY_NAMESPACE -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $REGISTRY_NAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $REGISTRY_NAME
  template:
    metadata:
      labels:
        app: $REGISTRY_NAME
    spec:
      containers:
      - name: $REGISTRY_NAME
        image: registry:2
        ports:
        - containerPort: 5000
EOF

# Step 3: Expose registry as a NodePort
kubectl apply -n $REGISTRY_NAMESPACE -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: $REGISTRY_NAME
spec:
  type: NodePort
  selector:
    app: $REGISTRY_NAME
  ports:
  - port: 5000
    targetPort: 5000
    nodePort: $REGISTRY_PORT
EOF

echo "⏳ Waiting for registry pod to be ready..."
kubectl wait --for=condition=ready pod -l app=$REGISTRY_NAME -n $REGISTRY_NAMESPACE --timeout=60s

# Step 4: Start port-forwarding in background
echo "🔌 Port-forwarding registry to $REGISTRY_PORT..."
kubectl port-forward -n $REGISTRY_NAMESPACE svc/$REGISTRY_NAME $REGISTRY_PORT:5000 > /dev/null 2>&1 &
PF_PID=$!

# Wait a moment for the port-forward to establish
sleep 3

# Step 5: Build and push images
echo "🚧 Building and pushing v1.0 and v2.0 images to in-cluster registry..."

# Events API v1
docker build --platform=linux/amd64 -t events-api:$V1_TAG ./events-api
docker tag events-api:$V1_TAG ${REGISTRY_ADDR}/events-api:$V1_TAG
docker push ${REGISTRY_ADDR}/events-api:$V1_TAG

# Events API v2
docker build --platform=linux/amd64 -t events-api:$V2_TAG ./events-api-v2
docker tag events-api:$V2_TAG ${REGISTRY_ADDR}/events-api:$V2_TAG
docker push ${REGISTRY_ADDR}/events-api:$V2_TAG

# Events Website v1
docker build --platform=linux/amd64 -t events-website:$V1_TAG ./events-website
docker tag events-website:$V1_TAG ${REGISTRY_ADDR}/events-website:$V1_TAG
docker push ${REGISTRY_ADDR}/events-website:$V1_TAG

# Events Website v2
docker build --platform=linux/amd64 -t events-website:$V2_TAG ./events-website-v2
docker tag events-website:$V2_TAG ${REGISTRY_ADDR}/events-website:$V2_TAG
docker push ${REGISTRY_ADDR}/events-website:$V2_TAG

echo "✅ All images pushed to in-cluster registry at $REGISTRY_ADDR"

# Step 6: Kill port-forward
kill $PF_PID

echo "🎉 Done. You're ready to deploy both v1 and v2 via Helm or Istio."
