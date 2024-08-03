#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_curl() {
    echo "curl is not installed. Installing curl..."
    if [[ "$os_type" == "Linux" ]]; then
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
    elif [[ "$os_type" == "Darwin" ]]; then
        if command_exists brew; then
            brew install curl
        else
            echo "Homebrew is not installed. Please install Homebrew first or install curl manually."
            exit 1
        fi
    else
        echo "Unsupported OS. Please install curl manually."
        exit 1
    fi
}

install_docker() {
    echo "Installing Docker..."
    if [[ "$os_type" == "Linux" ]]; then
        if command_exists apt; then
            sudo apt update && sudo apt install -y docker.io
        elif command_exists yum; then
            sudo yum install -y docker
        elif command_exists dnf; then
            sudo dnf install -y docker
        elif command_exists zypper; then
            sudo zypper install -y docker
        else
            echo "Unsupported package manager. Please install Docker manually."
            exit 1
        fi
        sudo systemctl start docker
        sudo systemctl enable docker
    elif [[ "$os_type" == "Darwin" ]]; then
        if command_exists brew; then
            brew install --cask docker
            echo "Please start Docker.app from Applications."
        else
            echo "Homebrew is not installed. Please install Homebrew first or install Docker manually."
            exit 1
        fi
    else
        echo "Unsupported OS. Please install Docker manually."
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
    if [[ "$os_type" == "Darwin" ]] || [[ "$os_type" == "Linux" ]] || grep -q Microsoft /proc/version; then
        echo "Moving $file to $target_dir..."
        sudo mv "$file" "$target_dir"
        echo "Minikube has been moved to $target_dir."
    else
        echo "Unsupported OS or environment. Please move $file to a directory in your PATH manually."
        exit 1
    fi
}

os_type=$(uname -s)
echo "Detected OS: $os_type"

if ! command_exists curl; then
    install_curl
fi

if ! command_exists docker; then
    install_docker
fi

case "$os_type" in
    Linux)
        if grep -q Microsoft /proc/version; then
            echo "Running on Windows Subsystem for Linux"
            minikube_url="https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe"
            output="minikube.exe"
        else
            echo "Running on native Linux"
            minikube_url="https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64"
            output="minikube"
        fi
        ;;
    Darwin)
        echo "Running on macOS"
        minikube_url="https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64"
        output="minikube"
        ;;
    *)
        echo "Unsupported OS: $os_type"
        exit 1
        ;;
esac

download_minikube "$minikube_url" "$output"
move_to_path "$output"

echo "Starting Minikube..."
minikube start

