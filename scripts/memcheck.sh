source /helper.sh

memcheck(){
    read total used <<< $(free -m | awk '/Mem:/ {print $2 " " $3}')
    echo "Current memory usage: $(awk '/MemTotal/{total=$2}/MemAvailable/{available=$2} END {printf "%.2f", (total-available)/total*100}' /proc/meminfo)%"

    # Calculate used memory as percentage of total
    used_pct=$((used * 100 / total))
    if [ "$used_pct" -gt 95 ]; then
        broadcast_message "[NOTICE]SERVER_MEMORY_HAS_EXCEEDED_95%"
	send_webhook_notification "SERVER_WILL_RESTART" "MEMORY EXCEEDED" "$WEBHOOK_UPDATE_VALIDATE_COLOR"
        sleep 1
	countdown_3m
        shutdown
    else
        broadcast_message "[INFO]SERVER_MEMORY_USED:${used_pct}%"
    fi
}

memcheck
