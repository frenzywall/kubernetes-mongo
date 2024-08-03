#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_curl() {
    echo "curl is not installed. Installing curl..."
    if [[ "$os_id" == "ubuntu" || "$os_id" == "debian" ]]; then
        sudo apt update && sudo apt install -y curl
    elif [[ "$os_id" == "centos" || "$os_id" == "rhel" ]]; then
        sudo yum install -y curl
    elif [[ "$os_id" == "fedora" ]]; then
        sudo dnf install -y curl
    elif [[ "$os_id" == "opensuse" ]]; then
        sudo zypper install -y curl
    else
        echo "Unsupported OS. Please install curl manually."
        exit 1
    fi
}

install_qemu() {
    echo "Installing QEMU..."
    if [[ "$os_id" == "ubuntu" || "$os_id" == "debian" ]]; then
        sudo apt update && sudo apt install -y qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
    elif [[ "$os_id" == "centos" || "$os_id" == "rhel" ]]; then
        sudo yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
    elif [[ "$os_id" == "fedora" ]]; then
        sudo dnf install -y @virtualization
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
    elif [[ "$os_id" == "opensuse" ]]; then
        sudo zypper install -y qemu-kvm libvirt virt-install
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
    else
        echo "Unsupported OS. Please install QEMU manually."
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

# Detect OS type
os_type=$(uname -s)
echo "Detected OS: $os_type"

# Determine the specific Linux distribution
if [ -e /etc/os-release ]; then
    . /etc/os-release
    os_id=$ID
elif command_exists lsb_release; then
    os_id=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
else
    echo "Unable to determine the Linux distribution."
    exit 1
fi

echo "Detected Linux Distribution: $os_id"

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
