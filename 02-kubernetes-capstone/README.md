curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH

istioctl install --set profile=demo -y


deploy process
* create cluster (eksctl)
* run istio install
* git clone
* run build_ecr.sh
* run helm chart
