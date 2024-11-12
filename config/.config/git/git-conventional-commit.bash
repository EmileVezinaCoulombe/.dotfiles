#!/bin/bash

# Save as ~/.local/bin/git-conventional-commit or similar location in your PATH
# Make executable with: chmod +x ~/.local/bin/git-conventional-commit

# Define commit types with descriptions
commit_types=(
    "feat: A new feature"
    "fix: A bug fix"
    "docs: Documentation only changes"
    "style: Changes that do not affect the meaning of the code"
    "refactor: A code change that neither fixes a bug nor adds a feature"
    "perf: A code change that improves performance"
    "test: Adding missing tests or correcting existing tests"
    "build: Changes that affect the build system or external dependencies"
    "ci: Changes to CI configuration files and scripts"
    "chore: Other changes that don't modify src or test files"
    "revert: Reverts a previous commit"
)

# Select type using fzf
type=$(printf "%s\n" "${commit_types[@]}" | fzf --height=40% --layout=reverse --border --prompt="Select commit type: " | cut -d: -f1)
[ -z "$type" ] && exit 1

# Optional scope
echo -n "Enter scope (optional): "
read -r scope
scope_str=""
[ ! -z "$scope" ] && scope_str="($scope)"

# Get commit message
echo -n "Enter commit message: "
read -r message
[ -z "$message" ] && exit 1

# Optional longer description using editor
echo -n "Add detailed description? (y/N): "
read -r add_desc
description=""
if [[ "$add_desc" =~ ^[Yy]$ ]]; then
    temp_file=$(mktemp)
    echo "# Enter detailed description of your changes. Lines starting with '#' will be ignored." > "$temp_file"
    echo "#" >> "$temp_file"
    $EDITOR "$temp_file"
    description=$(grep -v '^#' "$temp_file" | sed '/^$/d')
    rm "$temp_file"
fi

# Optional breaking change
echo -n "Is this a breaking change? (y/N): "
read -r breaking
breaking_str=""
if [[ "$breaking" =~ ^[Yy]$ ]]; then
    echo -n "Enter breaking change description: "
    read -r breaking_desc
    breaking_str="BREAKING CHANGE: $breaking_desc"
fi

# Construct the commit message
commit_msg="$type$scope_str: $message"
[ ! -z "$description" ] && commit_msg="$commit_msg\n\n$description"
[ ! -z "$breaking_str" ] && commit_msg="$commit_msg\n\n$breaking_str"

# Create the commit
echo -e "$commit_msg" | git commit -F -
