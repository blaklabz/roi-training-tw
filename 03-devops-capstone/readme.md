# AI API Chat Interface

This project is a lightweight Flask-based web application that lets users interact with OpenAI's GPT-4 via a web form or a REST API. It is containerized with Docker and deployed using Kubernetes and Istio, supporting blue/green deployments through versioned subsets.

---

## 🧠 Features

- Flask web app with HTML form and OpenAI GPT-4 integration
- `/` route: user-facing form interface
- `/ask` route: JSON-based POST API for programmatic access
- Kubernetes deployment with Helm and ArgoCD
- Istio Gateway and VirtualService support blue/green traffic split
- Secrets managed via Kubernetes for OpenAI API key

---

## 📦 Tech Stack

- **Python 3.11 + Flask**
- **OpenAI Python SDK**
- **Docker**
- **Kubernetes (EKS)**
- **Helm**
- **ArgoCD**
- **Istio Ingress Gateway**

---

## 🚀 Deployment Overview

### 1. Build and Push Image

Use Jenkins or manually run:

```bash
docker build --build-arg BACKGROUND_IMAGE=bg1.jpg -t <your-registry>/ai-api:v1 .
docker push <your-registry>/ai-api:v1

kubectl create secret generic openai-secret \
  --from-literal=OPENAI_KEY=<your-api-key>

helm upgrade --install ai-api ./charts/ai-api \
    --set image.tag=v1 \
    --set image.repository=<your-registry>/ai-api

http://<istio-external-ip>/

GET /healthz -> "OK"
