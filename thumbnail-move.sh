#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 input_file"
  exit 1
fi

input_file="$1"
backup_file="${input_file}.bak"
cp "$input_file" "$backup_file"

start_index=-1
end_index=-1
index=0

# Temporary files to store different parts of the file
temp_before=$(mktemp)
temp_thumbnail=$(mktemp)
temp_after=$(mktemp)

# Read the file line by line
while IFS= read -r line; do
  if [[ "$line" == *"; THUMBNAIL_BLOCK_START"* ]]; then
    start_index=$index
  elif [[ "$line" == *"; THUMBNAIL_BLOCK_END"* ]]; then
    end_index=$index
  fi

  # Categorizing lines based on indices
  if [[ $start_index -eq -1 ]]; then
    echo "$line" >> "$temp_before"
  elif [[ $start_index -ne -1 && $end_index -eq -1 ]]; then
    echo "$line" >> "$temp_thumbnail"
  else
    echo "$line" >> "$temp_after"
  fi

  ((index++))
done < "$input_file"

# Combine the lines: before, after, then the thumbnail block at the end
cat "$temp_before" "$temp_after" "$temp_thumbnail" > "$input_file"

# Remove temporary files
rm "$temp_before" "$temp_thumbnail" "$temp_after"

if [[ $start_index -eq -1 || $end_index -eq -1 ]]; then
  echo "Thumbnail block not found in the input file"
fi
