
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host systemd service crashed (instance) incident.
---

This incident type refers to the failure of a systemd service on a particular host instance. The incident could be triggered by various causes such as a software bug, hardware failure, or system overload. This type of incident can cause downtime or service disruption to the affected host instance, which may require immediate resolution to restore normal operations.

### Parameters
```shell
export SERVICE_NAME="PLACEHOLDER"

export IP_ADDRESS="PLACEHOLDER"

export SYSTEMD_SERVICE_NAME="PLACEHOLDER"

export HOST_INSTANCE="PLACEHOLDER"
```

## Debug

### Check the status of the systemd service on the affected host instance
```shell
systemctl status ${SERVICE_NAME}
```

### Check the systemd journal for logs related to the service crash
```shell
journalctl -u ${SERVICE_NAME} -b
```

### Check the system logs for any relevant error messages
```shell
dmesg | grep ${SERVICE_NAME}
```

### Check the CPU and memory usage on the affected host instance
```shell
top
```

### Check the disk usage and available space on the affected host instance
```shell
df -h
```

### Check the network connectivity on the affected host instance
```shell
ping ${IP_ADDRESS}
```

### Check the firewall rules on the affected host instance
```shell
iptables -L
```

### Check the hardware status of the affected host instance
```shell
sensors
```

### The host system's resources were overloaded due to high usage or traffic, causing the systemd service to fail.
```shell


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


```

## Repair

### Restart the systemd service on the affected host instance: This can be done to try and resolve the issue by manually restarting the systemd service on the affected host instance. If the failure was due to a temporary issue, the service should resume normal operations after restarting.
```shell


#!/bin/bash



# Replace ${HOST_INSTANCE} with the name of the affected host instance.

HOST_INSTANCE=${HOST_INSTANCE}



# Restart the systemd service on the affected host instance.

systemctl restart ${SYSTEMD_SERVICE_NAME}@${HOST_INSTANCE}.service



# Check the status of the systemd service to verify if it has resumed normal operations.

systemctl status ${SYSTEMD_SERVICE_NAME}@${HOST_INSTANCE}.service


```