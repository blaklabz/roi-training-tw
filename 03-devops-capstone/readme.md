# AI API Chat Interface

This project is a lightweight Flask-based web application that lets users interact with OpenAI's GPT-4 via a web form or a REST API. It is containerized with Docker and deployed using Kubernetes and Istio, supporting blue/green deployments through versioned subsets.

---

<pre>
📁 Project Folder Structure

```
03-devops-capstone/
├── ai-api/                         # Main application code and related configs
│   ├── app.py                      # Flask API source code
│   ├── backend.tf                  # Terraform config for backend services
│   ├── Dockerfile                  # Container definition for ai-api
│   ├── helm/                       # Helm chart for ai-api deployment
│   │   └── ai-api/
│   │       ├── Chart.yaml          # Helm chart metadata
│   │       ├── values.yaml         # Default Helm values
│   │       ├── values-v1.yaml      # Helm values for version 1
│   │       ├── values-v2.yaml      # Helm values for version 2
│   │       ├── secrets/            # Kubernetes secrets templates
│   │        ├── .dockerconfigjson  # file for storing secret
│   │       └── templates/          # Helm templates (deployment, service, gateway, etc.)
│   │        ├── _helpers.tpl       # resuable naming/labels
│   │        ├── deployment.yaml    # defines the ai-api pods
│   │        ├── destinationrule.yaml # controls the loadbalancing (istio)
│   │        ├── gateway.yaml       # expose the istio service
│   │        ├── service.yaml       # creates the istio service
│   │        ├── virtualservice.yaml  # routing rules of the service v1/v2 (istio)
│
│   ├── images/                     # images for background
│   │
│   ├── jenkins/                    # Modular Jenkins pipelines for code quality and security
│   │   │
│   │   ├── Jenkinsfile-checkov    # Runs scans on Terraform code for misconfigurations and security
│   │   ├── Jenkinsfile-deploy     # Pipeline that will deploy the helm chart. (non-istio)
│   │   ├── Jenkinsfile-ecr        # Main job that builds and pushes the image for the app and initiates pipelines.
│   │   ├── Jenkinsfile-flake8     # Performs Python linting and style checks and tests.
│   │   ├── Jenkinsfile-hadolint   # Lints Dockerfile looking for best-practice violations and general issues.
│   │   ├── Jenkinsfile-pytest     # Runs unit tests for the ai-api server.
│   │   ├── Jenkinsfile-semgrep    # Static code analayzer, used to catch security and logic flaws in python.
│   │   ├── Jenkinsfile-trivy      # Peforms an image scan to detect vulnerabilities in the container image.
│   │   └── Jenkinsfile-yamllint   # Lints yaml files such as the Kubernetes manifests and Helm values.
│   │
│   ├── requirements.txt            # Python dependencies
│   ├── templates/                  # HTML templates for the app
│   └── tests/                      # App-level test code
│   │    ├── .flake8               # tests for flake8
│   │    ├── test_app.py           # tests for pytest
│
├── infra-pipelines/                # Infrastructure CI/CD and deployment logic
│   └── jenkins/                    # Infra-level Jenkins pipelines (ArgoCD, Istio, destroy, etc.)
│   │    ├── Jenkinsfile-argocd    # Jenkins pipeline to install argoCD to the eks cluster
│   │    ├── Jenkinsfile-istio     # Jenkins pipeline to install istio to the eks cluster
│
├── readme.md                       # This file - project overview, usage, and instructions
```
</pre>


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
