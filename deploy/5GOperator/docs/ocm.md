# Open Cluster Manager

https://open-cluster-management.io/

The following instructions are derived from [here](https://open-cluster-management.io/getting-started/quick-start/)

Log into kubernetes hub cluster

## Clusteradm CLI

### Install

```
wget https://github.com/open-cluster-management-io/clusteradm/releases/download/v0.1.0-alpha.5/clusteradm_linux_amd64.tar.gz
cd ~
tar xzvf clusteradm_linux_amd64.tar.gz
```

### Export these variables

```
export HUB_CLUSTER_NAME=hub
export MANAGED_CLUSTER_NAME=cluster1
export CTX_HUB_CLUSTER=kind-hub
```

### Deploy a cluster manager on your hub cluster

Create context named `kind-hub` in your `~/.kube/conf`

and invoke

```
clusteradm init --context ${CTX_HUB_CLUSTER}
```

copy the generated command and replace "managed cluster name" with `cluster1`.

### Deploy a klusterlet agent

Log into kubernetes managed cluster

Create context named `cluster1-hub` in your `~/.kube/conf`


and invoke previously join command appending the context of your managed cluster

### Accept join request and verify

Log into kubernetes hub cluster

run

```
kubectl get csr -w --context ${CTX_HUB_CLUSTER} | grep ${MANAGED_CLUSTER_NAME}
```

ensure to get output like this

```
cluster1-tqcjj   33s   kubernetes.io/kube-apiserver-client   system:serviceaccount:open-cluster-management:cluster-bootstrap   Pending
```

accept it

```
clusteradm accept --clusters ${MANAGED_CLUSTER_NAME} --context ${CTX_HUB_CLUSTER}
```

### Verify ManagedCluster CR created successfully

Log into kubernetes hub cluster

```
kubectl get managedcluster
```

verify it has true in all corresponding values

### Label cluster with its name

In order to place workloads into this cluster, you need to label it with its name

Log into kubernetes hub cluster

```
kubectl label managedclusters/cluster1 name=cluster1 --overwrite
```