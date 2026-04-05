#!/bin/bash

# ==========================================
# COLOR PALETTE: CYBERPUNK & DARK SYSTEM
# ==========================================
C_RESET='\033[0m'
C_BLOOD='\033[1;31m'   # Red (Breach/Critical)
C_NEON='\033[1;32m'    # Neon Green (Safe)
C_GOLD='\033[1;33m'    # Gold (Warning)
C_VOID='\033[1;35m'    # Deep Purple (Header)
C_ICE='\033[1;36m'     # Ice Blue (Info)

# ==========================================
# PRO INITIALIZATION & ENVIRONMENT
# ==========================================
TARGET_DIR=$(pwd)
LOG_FILE="breach_audit_$(date +%Y%m%d_%H%M%S).log"

# Trap CTRL+C to exit cleanly
trap ctrl_c INT
function ctrl_c() {
    echo -e "\n$C_BLOOD[!] SCRIPT INTERRUPTED BY USER. ABORTING...$C_RESET"
    exit 1
}

# Advanced Function 1: Emulated Neural Progress Bar
loading_bar() {
    local width=30
    local progress=0
    
    echo -ne "$C_ICE[+] Establishing neural link to core system...$C_RESET\n"
    while [ $progress -le 100 ]; do
        local filled=$(( progress * width / 100 ))
        local empty=$(( width - filled ))
        printf "\r$C_VOID[$C_NEON"
        printf "%${filled}s" | tr ' ' '#'
        printf "$C_RESET"
        printf "%${empty}s" | tr ' ' '-'
        printf "$C_VOID]$C_ICE %d%%$C_RESET" "$progress"
        sleep 0.03
        progress=$(( progress + 5 ))
    done
    echo -e "\n"
}

# Advanced Function 2: Cyber Header Generator
show_header() {
    clear
    echo -e "$C_VOID"
    echo "      _ _    _ _____ _____ ______ "
    echo "     | | |  | |_   _/ ____|  ____|"
    echo "     | | |  | | | || |    | |__   "
    echo " _   | | |  | | | || |    |  __|  "
    echo "| |__| | |__| |_| || |____| |____ "
    echo " \____/ \____/|_____\_____|______|"
    echo -e "$C_RESET"
    echo -e "$C_ICE[+] System Breach Auditor - Global English Edition$C_RESET"
    echo -e "$C_ICE[+] Target Path      : $TARGET_DIR$C_RESET"
    echo -e "$C_ICE[+] Log Repository   : $LOG_FILE$C_RESET"
    echo -e "$C_VOID--------------------------------------------------$C_RESET"
    loading_bar
}

# Advanced Function 3: SUID Binary Abuse Vector Scan
audit_suid() {
    echo -e "$C_ICE[>] SCANNING: Exploitable SUID Binaries...$C_RESET"
    local dangerous_binaries=("python" "php" "find" "perl" "ruby" "nc" "netcat")
    local found=0

    local suid_files
    suid_files=$(find /usr/bin /usr/sbin -perm -4000 -type f 2>/dev/null)

    for bin in "${dangerous_binaries[@]}"; do
        if echo "$suid_files" | grep -w "$bin" > /dev/null; then
            echo -e "$C_BLOOD[!] CRITICAL: Exploitable binary '$bin' possesses active SUID bit!$C_RESET"
            echo "[CRITICAL] SUID vector exposed on: $bin" >> "$LOG_FILE"
            found=1
        fi
    done

    if [ $found -eq 0 ]; then
        echo -e "$C_NEON[✓] SECURE: No standard interpreter SUID vectors identified.$C_RESET"
    fi
}

# Advanced Function 4: Heuristic Web Shell & Backdoor Analysis
audit_web_backdoor() {
    echo -e "\n$C_ICE[>] SCANNING: Potential Web Backdoors & Shell Injections...$C_RESET"
    local dangerous_funcs=("eval(" "system(" "passthru(" "exec(" "shell_exec(" "base64_decode(")
    local found_backdoor=0

    for func in "${dangerous_funcs[@]}"; do
        local check
        check=$(grep -rn "$func" "$TARGET_DIR" --include="*.php" 2>/dev/null | head -n 5)
        
        if [ ! -z "$check" ]; then
            echo -e "$C_GOLD[!] WARNING: Suspicious function '$func' detected in PHP stack!$C_RESET"
            echo "$check" | while read -r line; do
                echo -e "    -> $line"
            done
            echo "[WARNING] Flagged $func inside active PHP files" >> "$LOG_FILE"
            found_backdoor=1
        fi
    done

    if [ $found_backdoor -eq 0 ]; then
        echo -e "$C_NEON[✓] SECURE: Web directory clear of standard flagged functions.$C_RESET"
    fi
}

# NEW!! Advanced Function 5: Permission Integrity Check
audit_permissions() {
    echo -e "\n$C_ICE[>] SCANNING: World-Writable Files (Privilege Vector)...$C_RESET"
    # Scans for files that anyone can write to in the current directory
    local writable_files
    writable_files=$(find "$TARGET_DIR" -maxdepth 3 -type f -perm -o+w 2>/dev/null)

    if [ ! -z "$writable_files" ]; then
        echo -e "$C_BLOOD[!] WARNING: World-writable files identified!$C_RESET"
        echo "$writable_files" | while read -r line; do
            echo -e "    -> $line"
        done
        echo "[CRITICAL] World-writable files exposed in web root" >> "$LOG_FILE"
    else
        echo -e "$C_NEON[✓] SECURE: File write permissions are locked down.$C_RESET"
    fi
}

# ==========================================
# CORE SYSTEM EXECUTION
# ==========================================
show_header
echo "Audit initialized on $(date)" > "$LOG_FILE"

# Running Modular Pro Functions
audit_suid
audit_web_backdoor
audit_permissions

echo -e "\n$C_VOID--------------------------------------------------$C_RESET"
echo -e "$C_ICE[+] Protocol Terminated. Review '$LOG_FILE' for the full dump!$C_RESET"
