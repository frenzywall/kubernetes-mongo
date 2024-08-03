#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_curl() {
    echo "curl is not installed. Installing curl..."
    if command_exists apt; then
        sudo apt update && sudo apt install -y curl
    elif command_exists yum; then
        sudo yum install -y curl
    elif command_exists dnf; then
        sudo dnf install -y curl
    elif command_exists zypper; then
        sudo zypper install -y curl
    else
        echo "Unsupported package manager. Please install curl manually."
        exit 1
    fi
}

install_qemu() {
    echo "Installing QEMU..."
    if command_exists apt; then
        sudo apt update && sudo apt install -y qemu qemu-kvm libvirt-bin bridge-utils virt-manager
    elif command_exists yum; then
        sudo yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
    elif command_exists dnf; then
        sudo dnf install -y @virtualization
        sudo systemctl start libvirtd
        sudo systemctl enable libvirtd
    elif command_exists zypper; then
        sudo zypper install -y qemu-kvm libvirt virt-install
        sudo systemctl start libvirtd
        sudo systemctl enable libvirtd
    else
        echo "Unsupported package manager. Please install QEMU manually."
        exit 1
    fi
}

download_minikube() {
    url=$1
    output=$2
    echo "Downloading Minikube from $url..."
    curl -Lo "$output" "$url"
    chmod +x "$output"
    echo "Minikube downloaded and made executable."
}

move_to_path() {
    local file=$1
    local target_dir="/usr/local/bin/"
    echo "Moving $file to $target_dir..."
    sudo mv "$file" "$target_dir"
    echo "Minikube has been moved to $target_dir."
}

os_type=$(uname -s)
echo "Detected OS: $os_type"

if ! command_exists curl; then
    install_curl
fi

if ! command_exists qemu-system-x86_64; then
    install_qemu
fi

minikube_url="https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64"
output="minikube"

download_minikube "$minikube_url" "$output"
move_to_path "$output"

echo "Starting Minikube..."
minikube start --driver=qemu2
