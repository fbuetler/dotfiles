# Raycast

Decrypt raycast config

```bash
INPUT_FILE="raycast.rayconfig"
PASSWORD="secret"
OUTPUT_FILE="$(basename "$INPUT_FILE" .rayconfig).json"

openssl enc -d -aes-256-cbc -nosalt -in "$INPUT_FILE" -k "$PASSWORD" 2>/dev/null | tail -c +17 | gunzip > "$OUTPUT_FILE"
```
