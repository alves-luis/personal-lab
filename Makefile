K3D_PORT ?= 8080
K3D_CLUSTER_NAME ?= test-cluster

deploy:
	@echo "Deploying k3d on port $(K3D_PORT)"
	k3d cluster create $(K3D_CLUSTER_NAME) -p "$(K3D_PORT):80@loadbalancer"
	terraform apply

clean:
	@echo "Deleting k3d cluster"
	terraform destroy
	k3d cluster delete $(K3D_CLUSTER_NAME)