#!/bin/bash

# ==========================================
cyber_reset='\033[0m'
cyber_blood='\033[1;31m'  # Merah (Breach/Critical)
cyber_neon='\033[1;32m'   # Hijau Neon (Safe/Infiltrated)
cyber_gold='\033[1;33m'   # Kuning Emas (Warning/Vulnerable)
cyber_void='\033[1;35m'   # Ungu Gelap (System Header)
cyber_ice='\033[1;36m'    # Biru Es (Info/Query)

echo -e "$cyber_void"
echo "      _ _    _ _____ _____ ______ "
echo "     | | |  | |_   _/ ____|  ____|"
echo "     | | |  | | | || |    | |__   "
echo " _   | | |  | | | || |    |  __|  "
echo "| |__| | |__| |_| || |____| |____ "
echo " \____/ \____/|_____\_____|______|"
echo -e "$cyber_reset"
echo -e "$cyber_ice[+] System Breach Scanner Loaded...$cyber_reset"
echo -e "$cyber_ice[+] Codename        : JUICE PROTOCOL$cyber_reset"
echo -e "$cyber_gold[!] STATUS          : Target Identification Mode$cyber_reset"
echo -e "$cyber_void--------------------------------------------------$cyber_reset"

# 1. CEK KERENTANAN SUID BINER (SUID Abuse Check)
echo -e "\n$cyber_void[>] SCANNING: Exploitable SUID Binaries...$cyber_reset"
suid_files=$(find /usr/bin /usr/sbin -perm -4000 -type f 2>/dev/null)

if echo "$suid_files" | grep -E "python|php|find|perl|ruby" > /dev/null; then
    echo -e "$cyber_blood[!] BREACH DETECTED! High-privilege interpreter found:$cyber_reset"
    echo "$suid_files" | grep -E "python|php|find|perl|ruby"
    echo -e "$cyber_gold[i] Vector: Privilege Escalation via SUID abuse is possible.$cyber_reset"
else
    echo -e "$cyber_neon[✓] SECURE: No standard interpreter has SUID bit set.$cyber_reset"
fi

# 2. CEK PASSWORD DI FILE CONFIG OJS (Hardcoded Credential Check)
echo -e "\n$cyber_void[>] SCANNING: Hardcoded Credentials in OJS Config...$cyber_reset"
if [ -f "config.inc.php" ]; then
    db_pass=$(grep "password" config.inc.php | head -n 1)
    if [ ! -z "$db_pass" ]; then
        echo -e "$cyber_gold[!] VULNERABILITY: Database credential exposed in config file!$cyber_reset"
        echo -e "$cyber_blood[!] Vector: Risk of credential reuse for root login.$cyber_reset"
    fi
else
    echo -e "$cyber_neon[✓] INFO: config.inc.php not found in current directory.$cyber_reset"
fi

# 3. CEK CRONTAB YANG IZINNYA TERLALU BEBAS (Cron Persistence Check)
echo -e "\n$cyber_void[>] SCANNING: Writable Cron Jobs (Persistence Vectors)...$cyber_reset"
bad_cron=$(find /etc/cron* -type f -perm -o+w 2>/dev/null)

if [ ! -z "$bad_cron" ]; then
    echo -e "$cyber_blood[!] BREACH DETECTED! World-writable file in cron directory:$cyber_reset"
    echo "$bad_cron"
    echo -e "$cyber_gold[i] Vector: Arbitrary code execution via scheduled tasks.$cyber_reset"
else
    echo -e "$cyber_neon[✓] SECURE: All cron directory permissions are locked.$cyber_reset"
fi

echo -e "\n$cyber_void--------------------------------------------------$cyber_reset"
echo -e "$cyber_ice[+] Protocol Terminated. Analyze the payload results above!$cyber_reset"
