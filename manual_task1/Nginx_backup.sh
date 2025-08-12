#!/bin/bash

DATE=$(date +%F)
tar -czvf /home/DOORA/tasks/Linux-Bash/Nginx_backup/Nginx_backup_dir/Nbackup-$DATE.tar.gz -C /etc/nginx .


