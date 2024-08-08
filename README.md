# kubernetes-mongo
# MongoDB and Mongo Express Deployment on Kubernetes

This repository provides configurations for deploying MongoDB and Mongo Express on a Kubernetes cluster. 

## Overview

The setup involves:
- **Secrets**: Securely storing sensitive information like MongoDB credentials.
- **ConfigMaps**: Managing configuration data for MongoDB connection.
- **Deployments**: Defining the desired state of the MongoDB and Mongo Express applications.
- **Services**: Exposing the MongoDB and Mongo Express applications to the network.

## Configuration Files

### MongoDB Secret

A Kubernetes Secret is used to store MongoDB root credentials securely. This ensures sensitive information such as usernames and passwords are not exposed directly in configuration files.

### MongoDB Deployment and Service

The MongoDB Deployment sets up a MongoDB instance with the necessary environment variables fetched from the Kubernetes Secret. The MongoDB Service exposes the MongoDB instance on port `27017` to allow other services to communicate with it.

### Mongo Express Deployment and Service

The Mongo Express Deployment sets up the Mongo Express web-based interface for MongoDB. It uses environment variables from the Kubernetes Secret and ConfigMap to configure the connection to MongoDB. The Mongo Express Service exposes the interface on port `8081`, allowing access through a LoadBalancer service type.

### MongoDB ConfigMap

A ConfigMap is used to provide the MongoDB service URL to the Mongo Express application, ensuring that Mongo Express can locate and connect to the MongoDB instance.

## How to Run

1. **Apply the Kubernetes Configurations**:
   - First, ensure you have `kubectl` installed and configured to communicate with your Kubernetes cluster.
   - Apply the configuration files using the following commands:
     ```bash
     kubectl apply -f mongo-secret.yaml
     kubectl apply -f mongo-configmap.yaml
     kubectl apply -f mongo.yaml
     kubectl apply -f mongo-express.yaml
     ```
   - These commands will create the necessary Secrets, ConfigMaps, Deployments, and Services in your Kubernetes cluster.

2. **Access Mongo Express**:
   - Once deployed, Mongo Express can be accessed through the LoadBalancer service. The service will be available at the external IP address assigned to it on port `30000` or `8081`, depending on your cluster configuration.

## Shell Scripts

### `Base64-encoder.sh`

This script encodes a username and password into base64 format. It prompts the user to enter a username and password, then outputs their base64-encoded values. This is useful for creating Kubernetes Secrets or other configurations that require base64-encoded credentials.

### `Making-executables.sh`

This script makes one or more files executable. It prompts the user to enter paths of files they want to make executable and then applies the `chmod +x` command to each specified file. This is useful for setting executable permissions on script files.

### `Start-from-here.sh`

This script automates the installation and setup of `curl`, `qemu`, and `minikube` on a Linux system. It:
- Checks if `curl` is installed and installs it if not.
- Installs `qemu` and its dependencies.
- Downloads and installs `minikube`.
- Moves the `minikube` binary to `/usr/local/bin` and starts `minikube` using the `qemu2` driver.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
