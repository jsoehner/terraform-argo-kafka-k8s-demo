# Manage Kubernetes Cluster with Terraform and Argo CD [![Twitter](https://img.shields.io/twitter/follow/piotr_minkowski.svg?style=social&logo=twitter&label=Follow%20Me)](https://twitter.com/piotr_minkowski)

In this project I'm demonstrating you how to use [Terraform](https://www.terraform.io/) together with [Argo CD](https://argo-cd.readthedocs.io/en/stable/) to create and manage the Kubernetes cluster on [Kind](https://kind.sigs.k8s.io/).

## Prerequisites
1. Terraform CLI installed
2. Docker

## Getting Started

You may the detailed explanation of that example repository in the following article: [Manage Kubernetes Cluster with Terraform and Argo CD](https://piotrminkowski.com/2022/06/28/manage-kubernetes-cluster-with-terraform-and-argo-cd/)

Modifications by Jeff Soehner
-----------------------------

I used a remote kind cluster using another setup script from cluster-1 repo (https://github.com/jsoehner/cluster-1)
This requires a VM with docker and kind environment setup prior to deployment. The setup script (https://github.com/jsoehner/cluster-1/blob/main/create-ubuntu-cluster-v1.sh) assumes you have mkcert installed and you have already configured your
system with a client certificate. (Outside of the scope of this demo)



First, clone that repo:
```shell
$ git clone https://github.com/jsoehner/terraform-argo-kafka-k8s-demo.git
$ cd terraform-argo-kafka-k8s-demo
```

Then initialize Terraform config: 
```shell
terraform init
```

Review the actions plan: 
```shell
terraform plan
```

Run the Terraform actions: 
```shell
terraform apply
```

## Results

After running the previous command you receive:
* 3-nodes Kind cluster running locally
* OLM (Operator Lifecycle Manager) installed on Kind
* Argo CD installed on Kind
* Kafka Strimzi operator ready to use
* 3-node Kafka cluster created on Kind
