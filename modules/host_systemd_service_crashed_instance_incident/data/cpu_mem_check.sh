

#!/bin/bash



# Get the current CPU usage

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')



# Get the current memory usage

MEMORY_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')



# Check if CPU or memory usage is over 90%

if (( $(echo "$CPU_USAGE > 90" | bc -l) )) || (( $(echo "$MEMORY_USAGE > 90" | bc -l) )); then

    # If usage is high, print an error message and restart the systemd service

    echo "High CPU or memory usage detected. Restarting systemd service..."

    systemctl restart ${SYSTEMD_SERVICE_NAME}

else

    # If usage is normal, print a success message

    echo "CPU and memory usage is normal."

fi