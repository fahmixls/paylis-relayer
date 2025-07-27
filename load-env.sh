#!/usr/bin/env bash

# Load .env from environment/.env into the shell
ENV_FILE=".env"

if [ ! -f "$ENV_FILE" ]; then
  echo ".env file not found at $ENV_FILE"
  exit 1
fi

# Detect shell
SHELL_NAME=$(basename "$SHELL")

echo "Detected shell: $SHELL_NAME"
echo "Loading environment variables from $ENV_FILE..."

case "$SHELL_NAME" in
  bash|zsh)
    # Export variables for bash/zsh
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
    echo "Environment variables loaded into $SHELL_NAME."
    ;;

  fish)
    # Export variables for fish
    while IFS='=' read -r key value; do
      # Skip comments and empty lines
      if [[ "$key" =~ ^\s*# ]] || [[ -z "$key" ]]; then
        continue
      fi
      # Remove surrounding quotes from value if any
      value="${value%\"}"
      value="${value#\"}"
      echo "set -gx $key \"$value\";" >> /tmp/load_env.fish
    done < "$ENV_FILE"

    echo "Run the following in fish to load environment:"
    echo "source /tmp/load_env.fish"
    ;;

  *)
    echo "Shell $SHELL_NAME not supported in this script."
    ;;
esac

