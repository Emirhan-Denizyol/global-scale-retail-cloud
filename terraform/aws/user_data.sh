#!/bin/bash
set -e

cat > /home/ec2-user/server.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer
import socket

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        hostname = socket.gethostname()
        message = f"""
        <html>
          <head><title>Hello AWS</title></head>
          <body>
            <h1>Hello AWS - Global Scale Retail Cloud</h1>
            <p>Served from a private EC2 instance behind an Application Load Balancer.</p>
            <p>Instance hostname: {hostname}</p>
          </body>
        </html>
        """
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(message.encode("utf-8"))

HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
PY

cat > /etc/systemd/system/hello-aws.service <<'SERVICE'
[Unit]
Description=Simple Hello AWS HTTP Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/ec2-user/server.py
Restart=always
User=ec2-user

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable hello-aws.service
systemctl start hello-aws.service
