#!/bin/bash

# Function to compare Go version numbers
compare_go_versions() {
    local version1=$1
    local version2=$2

    if [[ $version1 == $version2 ]]; then
        return 0
    fi

    IFS='.' read -ra ver1 <<< "$version1"
    IFS='.' read -ra ver2 <<< "$version2"

    for ((i=0; i<${#ver1[@]}; i++)); do
        if ((ver1[i] > ver2[i])); then
            return 1
        elif ((ver1[i] < ver2[i])); then
            return 2
        fi
    done

    return 0
}

# Paths to the files
file1="C:\Users\ADMIN\Desktop\automation/file1"
file2="C:\Users\ADMIN\Desktop\automation/file2"
file3="C:\Users\ADMIN\Desktop\automation/file3"

# Check if all files exist
if [[ ! -e $file1 || ! -e $file2 || ! -e $file3 ]]; then
    echo "Error: All files must exist."
    exit 1
fi

# Read Go versions from files
version1=$(grep -oP 'go\d+\.\d+\.\d+' "$file1")
version2=$(grep -oP 'go\d+\.\d+\.\d+' "$file2")
version3=$(grep -oP 'go\d+\.\d+\.\d+' "$file3")

# Use direct extraction if Go version format is known
if [[ -z "$version1" ]]; then
    version1=$(cat "$file1")
fi
# Print the extracted versions for debugging
echo "Version in $file1: $version1"
echo "Version in $file2: $version2"
echo "Version in $file3: $version3"

# Check if versions were found
if [[ -z "$version1" || -z "$version2" || -z "$version3" ]]; then
    echo "Error: Unable to extract Go versions from one or more files."
    exit 1
fi

# Compare versions of file2 and file3 directly
compare_go_versions "$version2" "$version3"
comparison_result_files=$?

# Update version in file2 and file3 based on the comparison
if [[ $comparison_result_files -eq 1 ]]; then
    echo "Updating $file2 and $file3 to higher Go version"
    awk -v new_version="$version1" '{gsub(/go[0-9]+\.[0-9]+\.[0-9]+/, new_version)} 1' "$file2" > "$file2.tmp" && mv "$file2.tmp" "$file2"
    awk -v new_version="$version1" '{gsub(/go[0-9]+\.[0-9]+\.[0-9]+/, new_version)} 1' "$file3" > "$file3.tmp" && mv "$file3.tmp" "$file3"
    echo "Update complete for $file2 and $file3."
elif [[ $comparison_result_files -eq 2 ]]; then
    echo "Updating $file2 and $file3 to lower Go version"
    awk -v new_version="$version1" '{gsub(/go[0-9]+\.[0-9]+\.[0-9]+/, new_version)} 1' "$file2" > "$file2.tmp" && mv "$file2.tmp" "$file2"
    awk -v new_version="$version1" '{gsub(/go[0-9]+\.[0-9]+\.[0-9]+/, new_version)} 1' "$file3" > "$file3.tmp" && mv "$file3.tmp" "$file3"
    echo "Update complete for $file2 and $file3."
else
    echo "Go version in $file1 is equal in $file2 and $file3. No update needed for $file2 and $file3."
fi
