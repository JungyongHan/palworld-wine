countdown_3m(){
      broadcast_message "[NOTICE]3MIN_LATER_SERVER_WILL_RESTART."
      broadcast_message "[WARNING]PLEASE_MOVE_TO_A_SAFE_LOCATION"
      sleep 120
      broadcast_message "[NOTICE]1MIN_LATER_SERVER_WILL_RESTART."
      broadcast_message "[WARNING]PLEASE_MOVE_TO_A_SAFE_LOCATION"
      sleep 30
      count=30
      while [ $count -gt 0 ]
      do
        broadcast_message "[NOTICE]${count}SEC_LATER_SERVER_WILL_RESTART."
        sleep 1
        ((count--))
      done
}

broadcast_message() {
    /usr/local/bin/rconcli -c /rcon.yaml "broadcast $(TZ='Asia/Seoul' date +'%H:%M')$1" &
}

shutdown(){
   /usr/local/bin/rconcli -c /rcon.yaml "save"
   /usr/local/bin/rconcli -c /rcon.yaml "shutdown 1"
}

generate_post_data() {
  cat <<EOF
{
  "content": "",
  "embeds": [{
    "title": "$1",
    "description": "$2",
    "color": "$3"
  }]
}
EOF
}


send_webhook_notification() {
if [[ -n $WEBHOOK_ENABLED ]] && [[ $WEBHOOK_ENABLED == "true" ]]; then

  local title="$1"
  local description="$2"
  local color="$3"
  # Debug Curl
  #curl --ssl-no-revoke -H "Content-Type: application/json" -X POST -d "$(generate_post_data "$title" "$description" "$color")" "$WEBHOOK_URL"
  # Prod Curl
  curl --silent --ssl-no-revoke -H "Content-Type: application/json" -X POST -d "$(generate_post_data "$title" "$description" "$color")" "$WEBHOOK_URL"
fi
}

#Aliases to use in scripts
send_start_notification() {
  send_webhook_notification "$WEBHOOK_START_TITLE" "$WEBHOOK_START_DESCRIPTION" "$WEBHOOK_START_COLOR"
}
send_stop_notification() {
  send_webhook_notification "$WEBHOOK_STOP_TITLE" "$WEBHOOK_STOP_DESCRIPTION" "$WEBHOOK_STOP_COLOR"
}
send_install_notification() {
  send_webhook_notification "$WEBHOOK_INSTALL_TITLE" "$WEBHOOK_INSTALL_DESCRIPTION" "$WEBHOOK_INSTALL_COLOR"
}
send_update_notification() {
  send_webhook_notification "$WEBHOOK_UPDATE_TITLE" "$WEBHOOK_UPDATE_DESCRIPTION" "$WEBHOOK_UPDATE_COLOR"
}
send_update_and_validate_notification() {
  send_webhook_notification "$WEBHOOK_UPDATE_VALIDATE_TITLE" "$WEBHOOK_UPDATE_VALIDATE_DESCRIPTION" "$WEBHOOK_UPDATE_VALIDATE_COLOR"
}
