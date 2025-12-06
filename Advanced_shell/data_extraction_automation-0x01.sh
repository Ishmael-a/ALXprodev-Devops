#!/bin/bash

# Task 1: Extract Pokémon Data
# Extracts name, height, weight, and type from data.json

DATA_FILE="data.json"

# Check if data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Error: $DATA_FILE not found. Run Task 0 first."
    exit 1
fi

# Extract name using jq
name=$(jq -r '.name' "$DATA_FILE" | sed 's/.*/\u&/')

# Extract height (in decimeters, convert to meters) using jq
height=$(jq -r '.height' "$DATA_FILE" | awk '{printf "%.1f", $1/10}')

# Extract weight (in hectograms, convert to kg) using jq
weight=$(jq -r '.weight' "$DATA_FILE" | awk '{printf "%.0f", $1/10}')

# Extract primary type using jq
type=$(jq -r '.types[0].type.name' "$DATA_FILE" | sed 's/.*/\u&/')

# Format and display output
echo "$name is of type $type, weighs ${weight}kg, and is ${height}m tall."