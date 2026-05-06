
#!/bin/bash

# --- Mission Integrity Audit & Remediation Script ---
# Identifies files deviating from vendor hashes and restores them.
# Generated from GenAI.mil
# Addresses Red Hat Enterprise Linux 9 Security Technical Implementation Guide V-257823

echo "[*] Starting cryptographic integrity check..."

# 1. Identify files where SHA256/MD5 hashes deviate (excluding config files)
mapfile -t CORRUPTED_FILES < <(rpm -Va --noconfig | awk '$1 ~ /..5/ && $2 != "c" {print $2}')

# Check if any files were found
if [ ${#CORRUPTED_FILES[@]} -eq 0 ]; then
    echo "[+] No cryptographic hash deviations detected. System integrity verified."
    exit 0
fi

echo "[!] Found ${#CORRUPTED_FILES[@]} files with hash deviations."

# 2. Identify the provider (package) for each file
PACKAGES=()
for FILE in "${CORRUPTED_FILES[@]}"; do
    # Use rpm -qf to find owner; queryformat ensures we get just the package name
    PKG=$(rpm -qf "$FILE" --queryformat "%{NAME}\n" 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "    - File: $FILE (Provider: $PKG)"
        PACKAGES+=("$PKG")
    fi
done
# 3. Filter for unique package names to avoid redundant reinstalls
UNIQUE_PACKAGES=($(printf "%s\n" "${PACKAGES[@]}" | sort -u))
# 4. Attempt Reinstallation
if [ ${#UNIQUE_PACKAGES[@]} -gt 0 ]; then
    echo "[*] Attempting reinstallation of affected packages..."
    if dnf reinstall -y "${UNIQUE_PACKAGES[@]}"; then
        echo "[+] Remediation successful. Packages restored to vendor state."
    else
        echo "[-------] ERROR: Reinstallation failed. Check network or repository status."
        exit 1
    fi
else
    echo "[-------] ERROR: Could not identify package providers for affected files."
    exit 1
fi
