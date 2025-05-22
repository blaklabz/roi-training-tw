# Capstone Chart

A Helm chart for deploying the Capstone project, which includes:

- A custom events API and website
- Grafana and Prometheus monitoring stack
- MariaDB as the application database
- Istio-based blue/green deployment support

---

## 🚀 Features

- **Blue/Green Deployments** via Istio VirtualServices and DestinationRules
- **Grafana Dashboards** auto-loaded from ConfigMaps
- **MariaDB** with PVC and customizable credentials
- **Prometheus** for metrics collection
- **Resource limits** and custom image tags via `values.yaml`

---

## 🧰 Prerequisites

- Kubernetes cluster (1.30+ recommended)
- Helm 3.x
- Istio installed and configured
---
## 📦 Installation

```bash
# power up and log into the EC2 in us-east-2 called kubernetes-tw
# navigate to the eksctlcluster directory
cd /home/ec2-user/eksctlcluster

# run the command to build the eks cluster
eksctl create cluster -f cluster.yaml

# wait for the cluster to build then navigate to the capstone chart directory
cd /home/ec2-user/k8s-capstone/roi-training-tw/02-kubernetes-capstone/capstone-chart/

# install the capstone helm chart
helm install capstone .

# using these endpoints access the services - #note HTTP not HTTPS
# when all the pods come up discover the service endpoints
kubectl get svc -n istio-system - # this will give you the web app's service endpoint
 # ***note*** - the initial page should show as busted and not working

kubectly get svc - # this will give you the grafana service endpoint
 # ***note*** - the password is set to admin/admin it will force you to set a new password
 # Once in grafana navigate to dashboards review the General Folder entries
    # Kubernetes Pod metrics
    # Istio pod metrics

# to see blue/green deployment with istio review the values.yaml in the root directory
vi /home/ec2-user/k8s-capstone/roi-training-tw/02-kubernetes-capstone/capstone-chart/values.yaml

# modify the v1/v2 values
#   to mimic canary - set v2 to 25 and v1 to 75
#   to mimic blue/green - set v1 100 to v2 100 and v1 to 0

# after the modifications update the Chart
helm upgrade capstone .
___

📦 Fresh Start Installation

# boot up your own ec2
# install the usual dev tools git helm docker etc...
# setup your eks cluster and install istio --
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y

# Ensure your sc is set to default and gp2
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# clone the repo
git clone https://github.com/blaklabz/roi-training-tw
# open the folder and locate eksctl
cd roi-training-tw/capstone-chart
helm install capstone .
