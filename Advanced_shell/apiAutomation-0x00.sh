#!/bin/bash

# Task 0: API Request Automation
# Fetches Pikachu data from PokeAPI and saves to data.json

API_URL="https://pokeapi.co/api/v2/pokemon/pikachu"
OUTPUT_FILE="data.json"
ERROR_FILE="errors.txt"

# Make API request and save response
response=$(curl -s -w "\n%{http_code}" "$API_URL")

# Extract HTTP status code (last line)
http_code=$(echo "$response" | tail -n 1)

# Extract response body (all lines except last)
response_body=$(echo "$response" | sed '$d')

# Check if request was successful
if [ "$http_code" -eq 200 ]; then
    echo "$response_body" > "$OUTPUT_FILE"
    echo "✅ Data successfully saved to $OUTPUT_FILE"
else
    error_msg="[$(date '+%Y-%m-%d %H:%M:%S')] Failed to fetch data for Pikachu. HTTP Status: $http_code"
    echo "$error_msg" >> "$ERROR_FILE"
    echo "❌ Error: Request failed with status code $http_code"
    echo "Error logged to $ERROR_FILE"
    exit 1
fi