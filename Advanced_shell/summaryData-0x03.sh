#!/bin/bash

# Task 3: Summarize Pokémon Data
# Generates CSV report with Pokemon stats and calculates averages

DATA_DIR="pokemon_data"
OUTPUT_CSV="pokemon_report.csv"

# Check if data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo "❌ Error: $DATA_DIR directory not found. Run Task 2 first."
    exit 1
fi

# Create CSV header
echo "Name,Height (m),Weight (kg)" > "$OUTPUT_CSV"

# Process each JSON file
for json_file in "$DATA_DIR"/*.json; do
    # Check if files exist
    if [ ! -e "$json_file" ]; then
        echo "❌ No JSON files found in $DATA_DIR"
        exit 1
    fi
    
    # Extract data using jq and format
    name=$(jq -r '.name' "$json_file" | sed 's/.*/\u&/')
    height=$(jq -r '.height' "$json_file" | awk '{printf "%.1f", $1/10}')
    weight=$(jq -r '.weight' "$json_file" | awk '{printf "%.1f", $1/10}')
    
    # Append to CSV
    echo "$name,$height,$weight" >> "$OUTPUT_CSV"
done

# Display results
echo "CSV Report generated at: $OUTPUT_CSV"
echo ""
cat "$OUTPUT_CSV" | column -t -s ','
echo ""

# Calculate averages using awk
awk -F',' '
    NR > 1 {
        sum_height += $2
        sum_weight += $3
        count++
    }
    END {
        if (count > 0) {
            avg_height = sum_height / count
            avg_weight = sum_weight / count
            printf "Average Height: %.2f m\n", avg_height
            printf "Average Weight: %.2f kg\n", avg_weight
        }
    }
' "$OUTPUT_CSV"