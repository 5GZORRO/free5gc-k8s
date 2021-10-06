# Private registry

Allocate a dedicated VM Ubuntu 20.04 with: 2 vCPU, 8 GB RAM, 100 GB disk (or more depending on the images to store)

## Start private docker registry

Log into the VM where the registry is going to run

```
sudo docker run -d -p 5000:5000 --name registry registry:2
```

Note: It's **important** to use port `5000`

## Update docker client nodes

Log into every VM that needs to access private registry

```
vi /etc/docker/daemon.json
```

add the registry with VM's public ipaddress per the below example

```
{
  "insecure-registries":["172.15.0.167:5000"]
}
```

restart docker

```
docker service stop
docker service start
```

## Copy images into registry

Update `ansible/inventory.yaml` accordingly

**Tip:** you may need to authenticate against your origin registry before running the below

```
cd ansible
ansible-playbook -i inventory.yaml entrypoint.yaml
```
