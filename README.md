# POC Bindplane monitoring Cassandra on K8s

This is a proof of concept for monitoring Cassandra clusters
with Bindplane, inside a Kubernetes cluster. This should work
for all clusters (Bare Metal, EKS, GKE, AKS, PKS, etc)

## Problem

By default, when deploying a Cassandra StatefulSet to GKE, you
will have a K8s service with ports 9042 and 9160. JMX 7199
is not exposed at the service because Cassandra's JMX defaults
to Localhost only.

## Solution

***Steps***
1) enable jmx to listen on all IPs with Authentication
 - set LOCAL_JMX=no
 - add jmxremote.password and jmxremote.access to /etc/cassandra
 - see `Dockerfile`
2) add port 7199 to the Cassandra service
 - see `cassandra.yaml`

***Problems***
This poc does several things wrong in order to simplify the
requirements of enabling remote JMX for Cassandra clusters
running inside Kubernetes

1) we disable the readyness probe because it is not compatible
with authentication. Ideally this would be replaced with an alternative.
2) we hardcode the jmx creds in the image, see `Dockerfile` in
this repo. In a perfect world, this would be passed into the
image at runtime.

We do not solve these issues in this repo because each customer
environment will look a little different, meaning the way we
handle these issues might not work for everyone.

## Usage

Deploy cassandra to your cluster
```
kubectl apply -f cassandra.yaml
```

Wait until all pods are running
```
kubectl get all
```

Deploy a Bindplane collector to your cluster, you can do this
in the web interface of your Bindplane Account.

Configure the Cassandra source within the Bindplane UI
1) add source --> cassandra
2) host: `cassandra.default.svc.cluster.local`
3) port: `7199`
4) credentials: `monitor` / `password`

The test connection should pass. Notice that we use a single
Bindplane collector and target the Cassandra service address.
The service will direct the collector to one of the Cassandra pods.
The Bindplane collector will determine the remaining pod's IP addresses
by querying the pod it is connecting to initially.
