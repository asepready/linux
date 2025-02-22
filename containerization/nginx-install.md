```sh
apt -y install nginx libnginx-mod-stream

# /etc/nginx/nginx.conf
# IP kubernetes node plane
stream {
    upstream k8s-api {
        server 192.168.122.128:6443;
    }
    server {
        listen 6443;
        proxy_pass k8s-api;
    }
}

# Enable nginx
unlink /etc/nginx/sites-enabled/default
systemctl restart nginx