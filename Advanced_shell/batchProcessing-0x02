#!/bin/bash

# Task 2 & 4: Batch Pokémon Data Retrieval with Error Handling and Retry Logic
# Fetches data for multiple Pokémon with retry mechanism

API_BASE="https://pokeapi.co/api/v2/pokemon"
OUTPUT_DIR="pokemon_data"
POKEMON_LIST=("bulbasaur" "ivysaur" "venusaur" "charmander" "charmeleon")
DELAY=1  # Delay between requests to avoid rate limiting
MAX_RETRIES=3

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to fetch Pokemon data with retry logic
fetch_pokemon() {
    local pokemon_name=$1
    local output_file="$OUTPUT_DIR/${pokemon_name}.json"
    local attempt=1
    
    echo "Fetching data for $pokemon_name..."
    
    while [ $attempt -le $MAX_RETRIES ]; do
        # Make API request
        response=$(curl -s -w "\n%{http_code}" "$API_BASE/$pokemon_name")
        
        # Extract HTTP status code
        http_code=$(echo "$response" | tail -n 1)
        
        # Extract response body
        response_body=$(echo "$response" | sed '$d')
        
        # Check if request was successful
        if [ "$http_code" -eq 200 ]; then
            echo "$response_body" > "$output_file"
            echo "Saved data to $output_file ✅"
            return 0
        else
            echo "⚠️  Attempt $attempt failed for $pokemon_name (HTTP: $http_code)"
            
            if [ $attempt -lt $MAX_RETRIES ]; then
                echo "Retrying in 2 seconds..."
                sleep 2
            else
                error_msg="[$(date '+%Y-%m-%d %H:%M:%S')] Failed to fetch $pokemon_name after $MAX_RETRIES attempts. HTTP Status: $http_code"
                echo "$error_msg" >> errors.txt
                echo "❌ Error: Could not fetch $pokemon_name. Logged to errors.txt"
                return 1
            fi
        fi
        
        ((attempt++))
    done
}

# Main loop to fetch all Pokemon
for pokemon in "${POKEMON_LIST[@]}"; do
    fetch_pokemon "$pokemon"
    
    # Add delay between requests to avoid rate limiting
    sleep $DELAY
done

echo ""
echo "Batch processing complete! ✨"