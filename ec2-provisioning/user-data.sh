#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx

# === Script Ends Above ===

# === Reference Notes ===
# This script installs and configures NGINX on Amazon Linux 2.
# It assumes yum is available (e.g., on Amazon Linux or RHEL-based distros).
# systemctl is used to enable and start the NGINX service.

# #!/bin/bash - (known as shebang, saying script should be interpreted and ran using the bash shell)
# THIS is essential to tell the OS what interpreter to use
# If using different distro may need to use different package manager like apt-get = Ubuntu/Debian-based systems
# Or dnf = Fedora-based systems
# Also assumes necessary repos and dependencies are already configured on the instance to allow for Nginx installation
# Nginx – popular web sever for serving static content (web pages) and handling web requests (traffic)
# Others are Apache HTTP Server and Apache Tomcat

# yum install -y nginx (yum package manager specific to certain Linux distros incl. amazon linux)

# systemctl enable nginx (allows nginx to start automatically on system boot, whenever EC2 instance is restarted, Nginx is started as well)

# systemctl start nginx (starts nginx after immediately being installed, web server becomes active and ready to serve pages)
