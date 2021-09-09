# 5G Operator

## 5ginitcontainer

5G operator framework uses an initcontainer that registers NF services with coreDNS.

Refer [here](https://github.ibm.com/WEIT/5ginitcontainer) for building the init-container image

## Build and run the operator

Log into kubernetes master

### Clone

```bash
cd ~
git clone git@github.ibm.com:WEIT/5GOperator.git
cd 5GOperator
git checkout master-hrl
```

### Build and deploy

build

```bash
make generate
make manifests
make docker-build docker-push
```

deploy

```bash
make deploy
```

Wait for controller pod to start

```
kubectl get pod -n 5g
```

## Install argo and argo-events

Refer [here](docs/argo.md) for installing argo and argo-events

## Apply common configuration

Run the below to add additional roles to `default` service account in `5g-core` namespace. These roles are used by initContainer and argo workflow

```
kubectl apply -f workflows/argo/role.yaml
```

apply common templates

```
kubectl apply -f  workflows/common-templates  -n 5g-core
```

## Deploy a 5G core instance via _Argo_

deploy core and wait for the flow to complete

```
argo -n 5g-core  submit workflows/argo/fiveg-core.yaml
```

deploy subnet and wait for the flow to complete

```
argo -n 5g-core  submit workflows/argo/fiveg-subnet.yaml --parameter-file workflows/argo/subnet-010203.json
```

deploy subnet and wait for the flow to complete

```
argo -n 5g-core  submit workflows/argo/fiveg-subnet.yaml --parameter-file workflows/argo/subnet-112233.json
```

deploy app (app is dependent on subnet 112233) and wait for the flow to complete

```
argo -n 5g-core  submit workflows/argo/fiveg-app.yaml --parameter-file workflows/argo/app.json
```

tear down the deployment

```
argo delete --all  -n 5g-core
```

## Deploy a 5G core instance via _Argo-events_

### Apply needed roles

Create argo-events-sa service account and bind it to argo-event's ClusterRole argo-events-role

```
kubectl apply -f workflows/argo-events/deploy/install-v1.1.0.yaml -n 5g-core
```

### Create default Eventbus

```
kubectl apply -f workflows/argo-events/deploy/eventbus.yaml -n 5g-core
```

### Create kafka event source

Update kafka ip and port settings per your environment

```
export KAFKA_HOST=172.15.0.170
export KAFKA_PORT=9092
```

create the source

```
envsubst < workflows/argo-events/kafka-event-source.yaml.template | kubectl create -n 5g-core -f -
```

**Note:** Kafka `5g-core-topic` is automatically created during the creation of the event sources

## Create main (branch) sensor

```
kubectl apply -f workflows/argo-events/fiveg-branch-sensor.yaml -n 5g-core
```

## Trigger events to deploy core/subnet/app

Connect to kafka container and invoke 

```bash
/opt/kafka/bin/kafka-console-producer.sh --topic 5g-core-topic  --bootstrap-server localhost:9092
```

deploy core

```
{"event_uuid": "123", "operation": "core"}
```

deploy subnet

```
{"event_uuid": "456", "operation": "subnet", "smf_name": "smf-sample","sst": "1","sd": "010203"}
```

deploy subnet

```
{"event_uuid": "789", "operation": "subnet", "smf_name": "smf-sample","sst": "1","sd": "112233", "network_name": "gilan", "network_master": "ens192", "network_range": "10.20.0.0/24", "network_start": "10.20.0.2", "network_end": "10.20.0.50", "smf_name": "smf-sample", "sst": "1", "sd": "112233"}
```

deploy vcache app

```
{"event_uuid": "012", "operation": "app", "network_name": "gilan"}
```
