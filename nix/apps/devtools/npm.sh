#!/bin/bash

# Define the global npm directory
NPM_GLOBAL_DIR="$HOME/.npm-global"

# Create the directory if it doesn't exist
mkdir -p "$NPM_GLOBAL_DIR"

# Configure npm to use this directory
npm config set prefix "$NPM_GLOBAL_DIR"
