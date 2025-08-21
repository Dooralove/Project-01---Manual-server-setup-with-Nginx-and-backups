
---

# 🚀 Проект 01 — Ручная настройка сервера с Nginx и бэкапами

## 📖 Описание

В этом проекте развёрнут веб-сервер на чистой виртуальной машине с Ubuntu 22.04.
Настроен доступ к серверу, создан статический сайт и автоматизировано резервное копирование конфигураций Nginx.

---

## ⚙️ Этапы выполнения

### 1️⃣ Запуск ВМ и подключение

* Создана чистая виртуальная машина с Ubuntu 22.04
* Подключение по SSH:

```bash
ssh user@SERVER_IP
```

---

### 2️⃣ Установка Nginx

```bash
sudo apt update
sudo apt install nginx -y
```

Проверка статуса:

```bash
sudo systemctl status nginx
```

---

### 3️⃣ Настройка Firewall (UFW)

Разрешены только необходимые порты:

```bash
sudo ufw allow 22    # 🔑 SSH
sudo ufw allow 80    # 🌐 HTTP
sudo ufw allow 443   # 🔒 HTTPS
sudo ufw enable
sudo ufw status
```

---

### 4️⃣ Пользователь www-data и сайт

Проверка пользователя:

```bash
id www-data
```

Создание папки сайта и index.html:

```bash
sudo mkdir -p /var/www/html
echo "<h1>Hello from Nginx</h1>" | sudo tee /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

---

### 5️⃣ Настройка Nginx

Файл `/etc/nginx/sites-available/default`:

```nginx
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
```

Применение конфигурации:

```bash
sudo nginx -t   # 📝 Проверка конфигурации
sudo systemctl reload nginx   # 🔄 Применение изменений
```

---

### 6️⃣ Скрипт для бэкапа конфигураций

Файл `nginx_backup.sh`:

```bash
#!/bin/bash
DATE=$(date +%F)
tar -czvf /home/USER/nginx-backups/nginx-config-$DATE.tar.gz -C /etc/nginx .
```

Сделать скрипт исполняемым:

```bash
chmod +x nginx_backup.sh
```

---

### 7️⃣ Настройка Cron для автоматического запуска

Открыть crontab:

```bash
crontab -e
```

Добавить задачу для еженедельного бэкапа (каждое воскресенье в 03:00):

```text
0 3 * * 0 /home/USER/nginx_backup.sh
```

---

### ✅ Результат

* 🌐 Статический сайт работает на Nginx
* 💾 Конфигурации Nginx автоматически сохраняются раз в неделю
* ⚡ Сервер готов к масштабированию и дальнейшей настройке

---


