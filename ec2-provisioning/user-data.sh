#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx

# === Script Ends Above ===

# === Reference Notes ===
# This script installs and configures NGINX on Amazon Linux 2.
# It assumes yum is available (e.g., on Amazon Linux or RHEL-based distros).
# systemctl is used to enable and start the NGINX service.
