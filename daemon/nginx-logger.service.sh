#!/bin/bash
#
# This script takes the specified nginx's *.log (No.0) and every SCIPT_PROCESSING_PAUSE copies the data from it to:
#
# No.1 - *.copy.log      (just copy with specified COPY_SIZE_B. Each time the COPY_SIZE_B size is reached, the file is cleared)
# No.2 - *.copy.info.log (records of when and how many rows of No.1 file were deleted)
# No.3 - *.4xx.log       (records with 4xx http code)
# No.4 - *.5xx.log       (records with 5xx http code)
#
#
# USAGE:
# This script is used via systemctl daemon. Make sure this script file is executable
#
# TO REMOVE:
# Stop *.service via systemctl, remove /etc/systemd/system/*.service, reload systemctl's daemon
#

# Editable variables
ACCESS_LOG_NAME="illusior"
COPY_SIZE_B=10000 # 307200
NGINX_LOG_DIR="/var/log/nginx"
SCIPT_PROCESSING_PAUSE=5
# Editable variables

ACCESS_LOG="$NGINX_LOG_DIR/$ACCESS_LOG_NAME.log"

LOG_COPY_FILE="$NGINX_LOG_DIR/$ACCESS_LOG_NAME.copy.log"
LOG_COPY_INFO_FILE="$NGINX_LOG_DIR/$ACCESS_LOG_NAME.copy.info.log"
LOG_4xx_FILE="$NGINX_LOG_DIR/$ACCESS_LOG_NAME.4xx.log"
LOG_5xx_FILE="$NGINX_LOG_DIR/$ACCESS_LOG_NAME.5xx.log"

LAST_START_COPY_POS_FILE="/tmp/nginx_logger.pos"

init_last_start_copy_pos_file()
{
    if [ ! -f "$LAST_START_COPY_POS_FILE" ]
    then
        echo 0 > "$LAST_START_COPY_POS_FILE"
    fi
}

get_last_copied_pos()
{
    if [ ! -f "$LAST_START_COPY_POS_FILE" ]
    then
        return 1
    fi
    
    cat "$LAST_START_COPY_POS_FILE"
    
    return 0
}

main()
{
    init_last_start_copy_pos_file
    
    while true
    do
        sleep $SCIPT_PROCESSING_PAUSE
        
        last_pos=$(get_last_copied_pos)
        
        new_lines=$(tail -c +$((last_pos + 1)) "$ACCESS_LOG")
        
        if [[ -z "$new_lines" ]]
        then
            continue
        fi
        
        echo "$new_lines" >> "$LOG_COPY_FILE"
        
        echo "$new_lines" | awk '$9 ~ /^4/ {print}' >> "$LOG_4xx_FILE"
        echo "$new_lines" | awk '$9 ~ /^5/ {print}' >> "$LOG_5xx_FILE"
        
        new_pos=$(stat -c%s "$ACCESS_LOG")
        echo "$new_pos" > "$LAST_START_COPY_POS_FILE"
        
        log_copy_file_size=$(stat -c%s "$LOG_COPY_FILE")
        if [[ "$log_copy_file_size" -gt "$COPY_SIZE_B" ]]
        then
            line_count=$(wc -l < "$LOG_COPY_FILE")
            
            truncate -s 0 "$LOG_COPY_FILE"
            
            echo "$(date '+%Y-%m-%d %H:%M:%S') - File \"$LOG_COPY_FILE\" is truncated, removed $line_count entries" >> "$LOG_COPY_INFO_FILE"
        fi
    done
}

main
