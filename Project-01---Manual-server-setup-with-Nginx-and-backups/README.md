---

## Проект 01 — Ручная настройка сервера с Nginx и бэкапами

### Описание

В этом проекте я разворачиваю веб-сервер на чистой виртуальной машине, настраиваю доступ к нему, создаю статический сайт и автоматизирую резервное копирование конфигураций Nginx.

---

## Этапы выполнения

### 1. Запуск ВМ и подключение

* Создана чистая виртуальная машина с Ubuntu 22.04.
* Подключение к серверу по SSH:

ssh user@SERVER_IP

---

### 2. Установка Nginx

sudo apt update
sudo apt install nginx -y

Проверка статуса:

sudo systemctl status nginx

---

### 3. Настройка firewall (UFW)

Разрешены только необходимые порты:

sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
sudo ufw status

---

### 4. Пользователь www-data и сайт

Проверка пользователя:

id www-data

Папка сайта:

sudo mkdir -p /var/www/html
echo "<h1>Hello from Nginx</h1>" | sudo tee /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

---

### 5. Настройка Nginx

Файл /etc/nginx/sites-available/default:

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}

Применение изменений:

sudo nginx -t
sudo systemctl reload nginx

---

### 6. Скрипт для бэкапа конфигураций

nginx_backup.sh:

#!/bin/bash
DATE=$(date +%F)
tar -czvf /home/USER/nginx-backups/nginx-config-$DATE.tar.gz -C /etc/nginx .

Делаем исполняемым:

chmod +x nginx_backup.sh

---

### 7. Настройка cron для еженедельного запуска

crontab -e

Добавляем строку (каждое воскресенье в 03:00):

0 3 * * 0 /home/USER/nginx_backup.sh
---


