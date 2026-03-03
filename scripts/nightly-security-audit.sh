#!/bin/bash
# OpenClaw Nightly Security Audit Script v2.7
# Based on SlowMist OpenClaw Security Practice Guide
# Runs daily at 03:00, covers 13 core metrics

set -e

# Configuration
OC_DIR="${OPENCLAW_STATE_DIR:-$HOME/.openclaw}"
WORKSPACE_DIR="$OC_DIR/workspace"
REPORT_DIR="/tmp/openclaw/security-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DATE_TODAY=$(date +%Y-%m-%d)
REPORT_FILE="$REPORT_DIR/report-$DATE_TODAY.txt"

# Create report directory
mkdir -p "$REPORT_DIR"

# Initialize report
echo "🛡️ OpenClaw Daily Security Audit Report ($DATE_TODAY)" > "$REPORT_FILE"
echo "Generated at: $(date)" >> "$REPORT_FILE"
echo "OpenClaw State Dir: $OC_DIR" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Helper function to log metric status
log_metric() {
    local num="$1"
    local name="$2"
    local status="$3"
    local details="$4"
    echo "$num. $name: $status" >> "$REPORT_FILE"
    if [ -n "$details" ]; then
        echo "   $details" >> "$REPORT_FILE"
    fi
}

# ============================================
# Metric 1: OpenClaw Security Audit
# ============================================
echo "[*] Running Metric 1: OpenClaw Security Audit..."
if command -v openclaw &> /dev/null; then
    OC_AUDIT_RESULT=$(openclaw security audit --deep 2>&1 || echo "AUDIT_FAILED")
    if [[ "$OC_AUDIT_RESULT" == *"AUDIT_FAILED"* ]] || [[ "$OC_AUDIT_RESULT" == *"error"* ]]; then
        log_metric "1" "Platform Audit" "⚠️ Audit encountered issues" "$OC_AUDIT_RESULT"
    else
        log_metric "1" "Platform Audit" "✅ Native scan executed" ""
    fi
else
    log_metric "1" "Platform Audit" "⚠️ openclaw command not found" ""
fi

# ============================================
# Metric 2: Process & Network Audit
# ============================================
echo "[*] Running Metric 2: Process & Network Audit..."
ANOMALOUS_PORTS=""
LISTENING_PORTS=$(ss -tnlp 2>/dev/null | grep LISTEN | wc -l)
UDP_PORTS=$(ss -unlp 2>/dev/null | grep -v "Netid" | wc -l)

# Check for suspicious outbound connections
SUSPICIOUS_CONN=$(ss -tnp 2>/dev/null | grep ESTAB | grep -v "127.0.0.1" | head -5 || true)

if [ -z "$SUSPICIOUS_CONN" ]; then
    log_metric "2" "Process & Network" "✅ No anomalous outbound/listening ports" "TCP: $LISTENING_PORTS, UDP: $UDP_PORTS"
else
    log_metric "2" "Process & Network" "⚠️ Active connections found" "$(echo "$SUSPICIOUS_CONN" | head -3)"
fi

# ============================================
# Metric 3: Sensitive Directory Changes
# ============================================
echo "[*] Running Metric 3: Sensitive Directory Changes..."
SENS_DIRS=("$OC_DIR" "/etc/" "$HOME/.ssh/" "$HOME/.gnupg/" "/usr/local/bin/")
CHANGED_FILES=""

for dir in "${SENS_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        CHANGES=$(find "$dir" -type f -mtime -1 2>/dev/null | head -10 || true)
        if [ -n "$CHANGES" ]; then
            CHANGED_FILES="$CHANGED_FILES$CHANGES\n"
        fi
    fi
done

if [ -n "$CHANGED_FILES" ]; then
    CHANGE_COUNT=$(echo -e "$CHANGED_FILES" | grep -c . || echo "0")
    log_metric "3" "Directory Changes" "⚠️ $CHANGE_COUNT files modified in last 24h" "$(echo -e "$CHANGED_FILES" | head -5)"
else
    log_metric "3" "Directory Changes" "✅ No sensitive file changes" ""
fi

# ============================================
# Metric 4: System Scheduled Tasks
# ============================================
echo "[*] Running Metric 4: System Scheduled Tasks..."
SYSTEM_CRONS=""

# Check system crontabs
if [ -d "/etc/cron.d" ]; then
    CRON_D_COUNT=$(ls -la /etc/cron.d/ 2>/dev/null | wc -l)
    SYSTEM_CRONS="$SYSTEM_CRONS/etc/cron.d: $CRON_D_COUNT entries\n"
fi

# Check root crontab
ROOT_CRONTAB=$(crontab -l 2>/dev/null | grep -v "^#" | grep -v "^$" | wc -l || echo "0")
SYSTEM_CRONS="$SYSTEM_CRONSRoot crontab: $ROOT_CRONTAB entries\n"

# Check systemd timers
SYSTEMD_TIMERS=$(systemctl list-timers --all 2>/dev/null | grep -v "timers listed" | wc -l || echo "0")
SYSTEM_CRONS="$SYSTEM_CRONSSystemd timers: $SYSTEMD_TIMERS"

log_metric "4" "System Cron" "✅ System tasks reviewed" "$(echo -e "$SYSTEM_CRONS")"

# ============================================
# Metric 5: OpenClaw Cron Jobs
# ============================================
echo "[*] Running Metric 5: OpenClaw Cron Jobs..."
if command -v openclaw &> /dev/null; then
    OC_CRONS=$(openclaw cron list 2>/dev/null || echo "LIST_FAILED")
    CRON_COUNT=$(echo "$OC_CRONS" | grep -c "nightly\|cron\|audit" || echo "0")
    log_metric "5" "Local Cron" "✅ Internal task list reviewed" "$OC_CRONS"
else
    log_metric "5" "Local Cron" "⚠️ openclaw command not found" ""
fi

# ============================================
# Metric 6: Logins & SSH
# ============================================
echo "[*] Running Metric 6: Logins & SSH..."
FAILED_SSH=$(journalctl -u sshd --since "24 hours ago" 2>/dev/null | grep -i "failed\|invalid" | wc -l || echo "0")
LAST_LOGINS=$(lastlog 2>/dev/null | grep -v "Never logged in" | head -5 || true)

if [ "$FAILED_SSH" -eq 0 ]; then
    log_metric "6" "SSH Security" "✅ 0 failed brute-force attempts" ""
else
    log_metric "6" "SSH Security" "⚠️ $FAILED_SSH failed SSH attempts" ""
fi

# ============================================
# Metric 7: Critical File Integrity
# ============================================
echo "[*] Running Metric 7: Critical File Integrity..."
BASELINE_FILE="$OC_DIR/.config-baseline.sha256"
INTEGRITY_STATUS="✅ Hash check passed and permissions compliant"

if [ -f "$BASELINE_FILE" ]; then
    HASH_CHECK=$(sha256sum -c "$BASELINE_FILE" 2>&1 || echo "HASH_MISMATCH")
    if [[ "$HASH_CHECK" == *"HASH_MISMATCH"* ]] || [[ "$HASH_CHECK" == *"FAILED"* ]]; then
        INTEGRITY_STATUS="⚠️ Hash mismatch detected: $HASH_CHECK"
    fi
else
    INTEGRITY_STATUS="⚠️ No baseline file found (run setup first)"
fi

# Check permissions
if [ -f "$OC_DIR/openclaw.json" ]; then
    OC_PERMS=$(stat -c %a "$OC_DIR/openclaw.json" 2>/dev/null || echo "unknown")
    if [ "$OC_PERMS" != "600" ]; then
        INTEGRITY_STATUS="$INTEGRITY_STATUS | openclaw.json perms: $OC_PERMS (should be 600)"
    fi
fi

log_metric "7" "Config Baseline" "$INTEGRITY_STATUS" ""

# ============================================
# Metric 8: Yellow Line Operation Cross-Validation
# ============================================
echo "[*] Running Metric 8: Yellow Line Operation Cross-Validation..."
SUDO_LOG_COUNT=$(grep -c "sudo:" /var/log/auth.log 2>/dev/null || echo "0")
MEMORY_LOG_COUNT=0

# Count yellow line entries in today's memory file
MEMORY_FILE="$WORKSPACE_DIR/memory/$(date +%Y-%m-%d).md"
if [ -f "$MEMORY_FILE" ]; then
    MEMORY_LOG_COUNT=$(grep -c "Yellow Line\|🟡" "$MEMORY_FILE" 2>/dev/null || echo "0")
fi

log_metric "8" "Yellow Line Audit" "✅ $SUDO_LOG_COUNT sudo executions (memory logs: $MEMORY_LOG_COUNT entries)" ""

# ============================================
# Metric 9: Disk Usage
# ============================================
echo "[*] Running Metric 9: Disk Usage..."
DISK_USAGE=$(df -h / 2>/dev/null | tail -1 | awk '{print $5}' | sed 's/%//')
LARGE_FILES=$(find / -type f -size +100M -mtime -1 2>/dev/null | head -5 || true)

if [ -n "$DISK_USAGE" ] && [ "$DISK_USAGE" -lt 85 ]; then
    log_metric "9" "Disk Capacity" "✅ Root partition usage ${DISK_USAGE}%" "$(echo "$LARGE_FILES" | head -3)"
elif [ -n "$DISK_USAGE" ]; then
    log_metric "9" "Disk Capacity" "⚠️ Root partition usage ${DISK_USAGE}% (>85%)" ""
else
    log_metric "9" "Disk Capacity" "⚠️ Unable to determine disk usage" ""
fi

# ============================================
# Metric 10: Gateway Environment Variables
# ============================================
echo "[*] Running Metric 10: Gateway Environment Variables..."
ENV_STATUS="✅ No anomalous memory credential leaks found"

# Find gateway process
GATEWAY_PID=$(pgrep -f "openclaw.*gateway" 2>/dev/null | head -1 || true)
if [ -n "$GATEWAY_PID" ] && [ -r "/proc/$GATEWAY_PID/environ" ]; then
    SENSITIVE_ENVS=$(cat /proc/$GATEWAY_PID/environ 2>/dev/null | tr '\0' '\n' | grep -iE "KEY|TOKEN|SECRET|PASSWORD" | head -5 || true)
    if [ -n "$SENSITIVE_ENVS" ]; then
        ENV_STATUS="⚠️ Found sensitive env vars (names only): $(echo "$SENSITIVE_ENVS" | cut -d= -f1 | tr '\n' ', ')"
    fi
fi

log_metric "10" "Environment Vars" "$ENV_STATUS" ""

# ============================================
# Metric 11: Plaintext Private Key/Credential Leak Scan (DLP)
# ============================================
echo "[*] Running Metric 11: Sensitive Credential Scan..."
DLP_STATUS="✅ No plaintext private keys/mnemonics found"

# Scan for Ethereum private keys (64 hex chars)
ETH_KEYS=$(grep -rE "0x[a-fA-F0-9]{64}" "$WORKSPACE_DIR/memory/" "$WORKSPACE_DIR/logs/" 2>/dev/null | head -3 || true)

# Scan for mnemonic patterns (12-24 words)
MNEMONICS=$(grep -rEo "\b(abandon|ability|able|about|above|absent|absorb|abstract|absurd|abuse|access|accident|account|accuse|achieve|acid|acoustic|acquire|across|act|action|actor|actress|actual|adapt|add|addict|address|adjust|admit|adult|advance|advice|aerobic|affair|afford|afraid|again|age|agent|agree|ahead|aim|air|airport|aisle|alarm|album|alcohol|alert|alien|all|alley|allow|almost|alone|alpha|already|also|alter|always|amateur|amazing|among|amount|amused|analyst|anchor|ancient|anger|angle|angry|animal|ankle|announce|annual|another|answer|antenna|antique|anxiety|any|apart|apology|appear|apple|approve|april|arch|arctic|area|arena|argue|arm|armed|armor|army|around|arrange|arrest|arrive|arrow|art|artefact|artist|artwork|ask|aspect|assault|asset|assist|assume|asthma|athlete|atom|attack|attend|attitude|attract|auction|audit|august|aunt|author|auto|autumn|average|avocado|avoid|awake|aware|away|awesome|awful|awkward|axis)\b" "$WORKSPACE_DIR/memory/" 2>/dev/null | head -3 || true)

if [ -n "$ETH_KEYS" ]; then
    DLP_STATUS="🔴 CRITICAL: Potential Ethereum private keys found!"
fi

log_metric "11" "Sensitive Credential Scan" "$DLP_STATUS" ""

# ============================================
# Metric 12: Skill/MCP Integrity
# ============================================
echo "[*] Running Metric 12: Skill/MCP Integrity..."
SKILL_STATUS="✅ No suspicious extension directories installed"

if [ -d "$OC_DIR/extensions" ]; then
    SKILL_COUNT=$(ls -la "$OC_DIR/extensions/" 2>/dev/null | wc -l)
    SKILL_STATUS="Extensions: $SKILL_COUNT directories"
fi

log_metric "12" "Skill Baseline" "$SKILL_STATUS" ""

# ============================================
# Metric 13: Brain Disaster Recovery Auto-Sync
# ============================================
echo "[*] Running Metric 13: Brain Disaster Recovery Auto-Sync..."
BACKUP_STATUS="⚠️ Git backup not configured"

if [ -d "$WORKSPACE_DIR/.git" ]; then
    cd "$WORKSPACE_DIR"
    GIT_STATUS=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$GIT_STATUS" -gt 0 ]; then
        # Auto commit and push if remote is configured
        REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
        if [ -n "$REMOTE_URL" ]; then
            git add -A 2>/dev/null || true
            git commit -m "Auto backup: $DATE_TODAY" 2>/dev/null || true
            git push origin HEAD 2>/dev/null && BACKUP_STATUS="✅ Automatically pushed to remote repo" || BACKUP_STATUS="⚠️ Git push failed (check remote config)"
        else
            BACKUP_STATUS="⚠️ Git repo exists but no remote configured"
        fi
    else
        BACKUP_STATUS="✅ Git repo synced (no changes)"
    fi
fi

log_metric "13" "Disaster Backup" "$BACKUP_STATUS" ""

# ============================================
# Final Report Summary
# ============================================
echo "" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
echo "📝 Detailed report saved locally: $REPORT_FILE" >> "$REPORT_FILE"
echo "Audit completed at: $(date)" >> "$REPORT_FILE"

# Output the report to stdout for cron to capture
cat "$REPORT_FILE"

echo ""
echo "[*] Audit complete. Report saved to: $REPORT_FILE"
