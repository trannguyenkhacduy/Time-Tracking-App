# Time-Tracking-App
23050030-23050051
Time Tracker Deployment Guide
To deploy the Time Tracker application on an Ubuntu server, follow these steps in sequence. First, update the system and install required packages by running sudo apt update && sudo apt upgrade -y and then sudo apt install -y python3 python3-pip python3-venv nginx git postgresql postgresql-contrib. Create a working directory with mkdir /var/www and move into it, then clone your GitHub repository using git clone <LINK_TO_YOUR_REPOSITORY> time_tracker. Navigate to the backend folder with cd time_tracker/backend, create a Python virtual environment using python3 -m venv venv, activate it with source venv/bin/activate, and install dependencies with pip install -r requirements.txt. Configure PostgreSQL by entering sudo -u postgres psql, creating a database and user, and granting privileges. Next, create a .env file in the backend directory to store environment variables such as DATABASE_URL and SECRET_KEY. Apply database migrations with alembic upgrade head. For the frontend, move into the frontend directory with cd /var/www/time_tracker/frontend, install dependencies using npm install, and build the project with npm run build. Replace the default Nginx HTML directory by running sudo rm -rf /var/www/html/* and copy the build output with sudo cp -r dist/* /var/www/html/. Configure Nginx by creating a new file at /etc/nginx/sites-available/time_tracker and adding the following configuration:
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;
    location / {
        try_files $uri /index.html;
    }
    location /api {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

Enable the site with sudo ln -s /etc/nginx/sites-available/time_tracker /etc/nginx/sites-enabled, test the configuration using sudo nginx -t, and restart Nginx with sudo systemctl restart nginx. Finally, create a systemd service for the backend by editing /etc/systemd/system/time_tracker.service with the following content:
[Unit]
Description=Time Tracker FastAPI
After=network.target
[Service]
User=ubuntu
WorkingDirectory=/var/www/time_tracker/backend
EnvironmentFile=/var/www/time_tracker/backend/.env
ExecStart=/var/www/time_tracker/backend/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target

Reload systemd with sudo systemctl daemon-reload, enable the service using sudo systemctl enable time_tracker, and start it with sudo systemctl start time_tracker. After completing these steps, the frontend will be accessible at http://<SERVER_IP> and the backend API will be available at http://<SERVER_IP>/api. Replace <LINK_TO_YOUR_REPOSITORY> with the actual GitHub repository link and adjust environment variables in .env according to your setup.
