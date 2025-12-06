#!/bin/bash

# Task 5: Parallel Data Fetching
# Fetches Pokemon data in parallel using background processes

API_BASE="https://pokeapi.co/api/v2/pokemon"
OUTPUT_DIR="pokemon_data"
POKEMON_LIST=("bulbasaur" "ivysaur" "venusaur" "charmander" "charmeleon")

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Array to store background process IDs
declare -a pids=()

# Function to fetch a single Pokemon (runs in background)
fetch_pokemon_parallel() {
    local pokemon_name=$1
    local output_file="$OUTPUT_DIR/${pokemon_name}.json"
    
    echo "[PID $$] Fetching data for $pokemon_name..."
    
    # Make API request
    response=$(curl -s -w "\n%{http_code}" "$API_BASE/$pokemon_name")
    
    # Extract HTTP status code
    http_code=$(echo "$response" | tail -n 1)
    
    # Extract response body
    response_body=$(echo "$response" | sed '$d')
    
    # Check if request was successful
    if [ "$http_code" -eq 200 ]; then
        echo "$response_body" > "$output_file"
        echo "[PID $$] Saved data to $output_file ✅"
    else
        error_msg="[$(date '+%Y-%m-%d %H:%M:%S')] [PID $$] Failed to fetch $pokemon_name. HTTP Status: $http_code"
        echo "$error_msg" >> errors.txt
        echo "[PID $$] ❌ Error: Could not fetch $pokemon_name"
    fi
}

# Export function so it's available to subshells
export -f fetch_pokemon_parallel
export API_BASE OUTPUT_DIR

echo "🚀 Starting parallel fetch for ${#POKEMON_LIST[@]} Pokemon..."
echo ""

# Launch background processes for each Pokemon
for pokemon in "${POKEMON_LIST[@]}"; do
    fetch_pokemon_parallel "$pokemon" &
    pids+=($!)  # Store the process ID
done

# Wait for all background processes to complete
echo "⏳ Waiting for all processes to complete..."
for pid in "${pids[@]}"; do
    wait $pid
done

echo ""
echo "✨ All parallel fetches complete!"
echo "📁 Data saved in $OUTPUT_DIR/"