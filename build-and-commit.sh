#!/bin/bash

# Define the branches
MAIN_BRANCH="main"
TARGET_BRANCH="gh-pages"
BUILD_FOLDER="build"
NOJEKYLL_FILE=".nojekyll"

# Ensure you are in the git repository
if [ ! -d ".git" ]; then
  echo "This script must be run from the root of a git repository."
  exit 1
fi

# Check if a commit message was provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 '<commit-message>'"
  exit 1
fi

COMMIT_MESSAGE="$1"

# Run the build command
npm run build
if [ $? -ne 0 ]; then
  echo "Build failed. Exiting."
  exit 1
fi

# Switch to the main branch (local)
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Failed to switch to branch $MAIN_BRANCH."
  exit 1
fi

# Copy the build folder contents to a temporary location
TEMP_DIR=$(mktemp -d)
cp -r $BUILD_FOLDER/* $TEMP_DIR
if [ $? -ne 0 ]; then
  echo "Failed to copy the contents of the build folder."
  exit 1
fi

# Switch to branch-2 (local)
git checkout $TARGET_BRANCH
if [ $? -ne 0 ]; then
  echo "Failed to switch to branch $TARGET_BRANCH."
  exit 1
fi

# Copy the contents of the temporary directory to the root of branch-2
cp -r $TEMP_DIR/* .
if [ $? -ne 0 ]; then
  echo "Failed to copy the contents to the root of the $TARGET_BRANCH branch."
  exit 1
fi

# Add the .nojekyll file at the root of the branch-2
touch $NOJEKYLL_FILE
if [ $? -ne 0 ]; then
  echo "Failed to create the $NOJEKYLL_FILE file."
  exit 1
fi

# Add and commit the changes (local)
git add .nojekyll *
git commit -m "$COMMIT_MESSAGE"
if [ $? -ne 0 ]; then
  echo "Failed to commit the changes."
  exit 1
fi

# Clean up
rm -rf $TEMP_DIR

# Switch back to the main branch (local)
git checkout $MAIN_BRANCH
if [ $? -ne 0 ]; then
  echo "Failed to switch back to $MAIN_BRANCH."
  exit 1
fi

echo "Build folder contents successfully copied from $MAIN_BRANCH to $TARGET_BRANCH, .nojekyll file added, and committed locally with message: '$COMMIT_MESSAGE'."
