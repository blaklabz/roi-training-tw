# ROI Training

Welcome to the **ROI Training Project**, a hands-on DevOps training environment built to simulate real-world infrastructure and deployment challenges.

This repository contains all components necessary to build and manage a modern cloud-native microservices stack using:

- 🐳 Docker + Kubernetes
- 📈 Grafana + Prometheus monitoring
- 🛠️ Helm + Infrastructure as Code (IaC)
- 🧩 Istio for advanced traffic routing (blue/green deployment)
- 🗃️ MariaDB for persistent state

---

## 📂 Repository Structure
* roi-training-tw/
  * 01-terraform-capstone
     * packer-code
     * simple_vm
     * website
     * README.md
  * 02-kubernetes-capstone
     * capstone-chart - (helm chart)
     * events-api
     * events-api-v2
     * events-website
     * events-website-v2
     * build_ecr.sh   - (creates the repo and builds and pushes images to ecr)
     * build_local.sh - (an attempt at creating a repo in kubernetes to push too)
     * cluster.yaml
     * README.md
* README.md               <----- # You’re here!!!
