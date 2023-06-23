# Personal Lab

To recreate this using your local machine, make sure you have k3d installed.
You can configure the port and name of the cluster using the following environment variables:

```
export K3D_PORT=8080
export K3D_CLUSTER_NAME=test-cluster
```

You can deploy the cluster and apply the terraform configuration using:

```
make deploy
```

You can clean it up using:

```
make clean
```