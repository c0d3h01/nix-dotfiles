#!/usr/bin/env bash

KEYS_DIR="secrets/keys"
SECRETS_DIR="secrets"

# Generate a new key
gen_key() {
  local name="$1"
  [[ -z "$name" ]] && {
    echo "Usage: $0 gen-key NAME"
    exit 1
  }

  age-keygen -o "$KEYS_DIR/$name.key"
  echo "Key created: $KEYS_DIR/$name.key"

  # Create recipients file automatically
  update_recipients
}

# Update recipients file from all keys
update_recipients() {
  : >"$SECRETS_DIR/recipients.txt"
  for key in "$KEYS_DIR"/*.key; do
    [[ -f "$key" ]] || continue
    grep "^# public key:" "$key" | cut -d ' ' -f 4 >>"$SECRETS_DIR/recipients.txt"
  done
  echo "Recipients file updated with $(wc -l <"$SECRETS_DIR/recipients.txt") keys"
}

# Encrypt a secret
encrypt() {
  local name="$1"
  [[ -z "$name" ]] && {
    echo "Usage: $0 encrypt NAME"
    exit 1
  }

  echo "Enter secret value (press Ctrl+D when done):"
  cat | age -e -R "$SECRETS_DIR/recipients.txt" -o "$SECRETS_DIR/$name.age"
  echo "Secret encrypted to $SECRETS_DIR/$name.age"
}

# Decrypt a secret
decrypt() {
  local name="$1"
  local key="${2:-$(basename $(ls "$KEYS_DIR"/*.key | head -1) .key)}"

  [[ -z "$name" ]] && {
    echo "Usage: $0 decrypt NAME [KEY]"
    exit 1
  }
  [[ ! -f "$SECRETS_DIR/$name.age" ]] && {
    echo "Secret $name not found"
    exit 1
  }

  age -d -i "$KEYS_DIR/$key.key" "$SECRETS_DIR/$name.age"
}

# List all keys and secrets
list() {
  echo "Available keys:"
  ls -1 "$KEYS_DIR" | grep '\.key$' | sed 's/\.key$//'

  echo -e "\nAvailable secrets:"
  ls -1 "$SECRETS_DIR" | grep '\.age$' | sed 's/\.age$//'
}

# Main command handler
case "${1:-help}" in
gen-key) gen_key "$2" ;;
encrypt) encrypt "$2" ;;
decrypt) decrypt "$2" "$3" ;;
list) list ;;
*) echo "Usage: $0 {gen-key|encrypt|decrypt|list} [args...]" ;;
esac
