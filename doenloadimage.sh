#!/bin/bash

# Function to echo the latest Go version
echo_latest_go_version() {
    local latest_version=$(curl -sSL https://golang.org/dl/?mode=json | grep -oP '"version": "\K[^"]+' | head -n 1 | sed 's/^go/go/')
    echo "Latest Go version: $latest_version"
}

# Function to compare two Go version numbers
compare_go_versions() {
    local version1=$1
    local version2=$2
    if [ "$(printf "$version1\n$version2" | sort -V | tail -n 1)" == "$version1" ]; then
        return 1  # version1 is strictly greater
    else
        return 0  # version2 is greater or equal
    fi
}

# Function to download the Go version
download_go_version() {
    local download_link=$1
    local version=$2
 if [ "$(printf "$version1\n$version2" | sort -V | tail -n 1)" == "$version1" ]; then
        return 1  # version1 is strictly greater
    else
        return 0  # version2 is greater or equal
    fi
}

# Function to download the Go version
download_go_version() {
    local download_link=$1
    local version=$2
    echo "Downloading Go version: $version"
    if wget "$download_link"; then
        echo "Go download successful."
    else
        echo "Error: Go download failed."
        exit 1
    fi
}

# Path to the file containing the installed Go version
file1="C:\Users\ADMIN\Desktop\automation/file1"

# Check if the file exists
if [[ ! -e $file1 ]]; then
    echo "Error: $file1 must exist."
    exit 1
fi

# Get the latest Go version and the download link
latest_version=$(curl -sSL https://golang.org/dl/?mode=json | grep -oP '"version": "\K[^"]+' | head -n 1 | sed 's/^go/go/')
download_link="https://go.dev/dl/$latest_version.linux-amd64.tar.gz"

# Print the latest Go version
echo_latest_go_version

# Read Go version from file1
current_version=$(cat "$file1")

# Print the extracted versions for debugging
echo "Version in $file1: $current_version"
# Compare versions
compare_go_versions "$current_version" "$latest_version"
comparison_result=$?

if [[ $comparison_result -eq 0 ]]; then
    echo "The installed Go version is older than the latest version."
    # Download and install the latest Go version
    download_go_version "$download_link" "$latest_version"
    # Update version in file1
    echo "$latest_version" >"$file1"
    echo "Go download and update complete."
else
    echo "The installed Go version is equal to or newer than the latest version. No update needed."
fi
