K3D_PORT ?= 8080
K3D_CLUSTER_NAME ?= test-cluster

deploy:
	@echo "Deploying k3d on port $(K3D_PORT)"
	k3d cluster create $(K3D_CLUSTER_NAME) -p "$(K3D_PORT):80@loadbalancer"
	terraform apply -var="cluster_name=$(K3D_CLUSTER_NAME)"

clean:
	@echo "Deleting k3d cluster"
	terraform destroy -var="cluster_name=$(K3D_CLUSTER_NAME)"
	k3d cluster delete $(K3D_CLUSTER_NAME)