[![Beszel](https://img.shields.io/badge/Beszel-0.15.0-blue.svg)](https://github.com/henrygd/beszel/releases/tag/v0.12.12)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/chilian/beszel_on_dokku/graphs/commit-activity)

# Run Beszel Hub on Dokku
This repository provides a simple way to deploy [Beszel](https://beszel.dev/), a lightweight and open-source monitoring tool, on a [Dokku](https://dokku.com/) host.  
Dokku acts as a mini-PaaS on top of Docker, making deployment and management straightforward.


**Note:** This project is a wrapper that adds an extra deployment layer on top of Beszel, primarily created as a hobby/tinkering project. You can also deploy Beszel directly using the official Docker image via `dokku git:sync`.

This project is not affiliated with Beszel.

---

## ⚡ Quick Start

```bash
# Create the app
dokku apps:create beszel

# Setup persistent storage
dokku storage:ensure-directory beszel_data
dokku storage:mount beszel /var/lib/dokku/data/storage/beszel_data:/beszel_data

# Set domain
dokku domains:set beszel beszel.example.com

# Map internal port 8090 to external port 3022 (adjust as needed)
dokku ports:set beszel http:3022:8090
dokku ports:set beszel https:3022:8090

# Deploy via git:sync
dokku git:sync --build beszel https://github.com/chilian/beszel_on_dokku.git
```

Access your instance at:
👉 http://beszel.example.com:3022

⚠️ **Security note**: I recommend running Beszel internally only and restricting access (e.g., via firewall, VPN, or private network). Avoid exposing it to the public internet without proper access controls.

## 📦 Prerequisites

Before proceeding, ensure you have the following:

- A working [Dokku host](https://dokku.com/docs/getting-started/installation/)
- (Optional) The [Let's Encrypt plugin](https://github.com/dokku/dokku-letsencrypt) for HTTPS

## 🚀 Deployment Methods

### Option 1: Using git:sync (recommended)
```bash
dokku git:sync --build beszel https://github.com/chilian/beszel_on_dokku.git
```

### Option 2: Manual clone & push
```bash
# Clone this repository
git clone https://github.com/chilian/beszel_on_dokku.git
cd beszel_on_dokku

# Add your Dokku server as remote
git remote add dokku dokku@example.com:beszel

# Push to deploy
git push dokku main
```

## 🔒 Enabling SSL (optional)
 ```bash
# Add HTTPS port
dokku ports:add beszel https:443:8090

# Install Let's Encrypt plugin
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

# Set contact email
dokku letsencrypt:set beszel email you@example.com

# Enable SSL
dokku letsencrypt:enable beszel
```

## 🔄 Updating Beszel
To upgrade to the latest Beszel version with git:sync:
```bash
dokku git:sync --build beszel https://github.com/chilian/beszel_on_dokku.git
```
This will rebuild and restart your container with the latest version.
Persistent data in /beszel_data will be preserved.

## ✅ Wrapping Up
Your Beszel instance should now be running on your Dokku host 🎉
Happy monitoring!

## 📜 License
[MIT License](https://github.com/chilian/beszel_on_dokku/blob/main/LICENSE) © Christoph Chilian
