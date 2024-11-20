#!/bin/bash

# Usage: ./validate.sh <theorem_name> <proof_content>
# Returns: "valid" or "invalid"

THEOREM_NAME=$1
PROOF_CONTENT=$2
TEMP_FILE=$(mktemp)

# Write proof to temporary file
echo "$PROOF_CONTENT" > "$TEMP_FILE"

# Run Lean validator
lean validate.lean "$THEOREM_NAME" "$TEMP_FILE"

# Clean up
rm "$TEMP_FILE"
