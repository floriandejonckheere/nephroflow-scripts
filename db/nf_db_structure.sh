nf_function nf_db_structure "Resolve schema migration conflicts in structure.sql automatically"
function nf_db_structure() {(set -euo pipefail\
  # Older versions sort the migrations in reverse order, so we need to reverse them if requested
  if [[ "${1:-}" == "reverse" ]]; then
    REVERSE=true
  else
    REVERSE=false
  fi

  # Path to structure.sql
  STRUCTURE_FILE="${NF_PATH}/nephroflow-api/db/structure.sql"

  # Create a temporary file for output
  TEMP_FILE=$(mktemp)

  # Find the line number of schema migrations
  MIGRATIONS_LINE=$(grep -n "INSERT INTO \"schema_migrations\"" "${STRUCTURE_FILE}" | cut -d':' -f1 || { echo "Could not find schema migrations in ${STRUCTURE_FILE}"; exit 1; })

  # Check for merge conflicts before migrations
  if head -n "${MIGRATIONS_LINE}" "${STRUCTURE_FILE}" | grep -q "^<<<<<<< \|^======= \|^>>>>>>> "; then
      echo "Merge conflict found before schema migrations. Please resolve the conflict manually."
      exit 1
  fi

  # Extract the part before migrations
  head -n "${MIGRATIONS_LINE}" "${STRUCTURE_FILE}" > "${TEMP_FILE}"

  # Extract and process migrations
  MIGRATIONS_TMP=$(mktemp)
  tail -n "+$((MIGRATIONS_LINE + 1))" "${STRUCTURE_FILE}" | grep -v "^$" | grep -v "^<<<<<<<\|^=======\|^>>>>>>>" | tr ";" "," | sort -u > "${MIGRATIONS_TMP}"

  # Reverse if requested (default)
  if [[ "$REVERSE" == false ]]; then
      REVERSED_TMP=$(mktemp)
      tac "${MIGRATIONS_TMP}" > "${REVERSED_TMP}"
      mv "${REVERSED_TMP}" "${MIGRATIONS_TMP}"
  fi

  # Replace last comma with semicolon in the last line
  gsed -i '$ s/,$/;/' "${MIGRATIONS_TMP}"

  # Combine the files
  cat "${TEMP_FILE}" "${MIGRATIONS_TMP}" > "${STRUCTURE_FILE}"

  # Clean up
  rm "${TEMP_FILE}" "${MIGRATIONS_TMP}"

  echo "Resolved merge conflicts in db/structure.sql"
)}
