#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
systemctl enable nginx -y
systemctl start nginx -y