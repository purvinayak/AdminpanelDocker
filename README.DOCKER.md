# Docker Setup for Admin Panel

This document provides instructions for building and running the Admin Panel React application in Docker.

## 📋 Prerequisites

- Docker installed ([Download Docker Desktop](https://www.docker.com/products/docker-desktop))
- Docker Hub account (for pushing images)

## 🚀 Quick Start

### 1. Build the Docker Image

```bash
docker build -t admintaskmanager:latest .
```

Or with a custom tag:

```bash
docker build -t username/admintaskmanager:1.0.0 .
```

### 2. Run the Container

```bash
docker run -p 3001:3001 -p 80:80 --name admin-panel admintaskmanager:latest
```

Access the application at:
- **React App**: `http://localhost`
- **API Server**: `http://localhost:3001`

### 3. Stop the Container

```bash
docker stop admin-panel
docker rm admin-panel
```

## 🐳 Using Docker Compose (Recommended)

### Start the Application

```bash
docker-compose up -d
```

### View Logs

```bash
docker-compose logs -f app
```

### Stop the Application

```bash
docker-compose down
```

## 📦 Push to Docker Hub

### 1. Login to Docker Hub

```bash
docker login
```

### 2. Tag Your Image

```bash
docker tag admintaskmanager:latest username/admintaskmanager:1.0.0
docker tag admintaskmanager:latest username/admintaskmanager:latest
```

### 3. Push to Docker Hub

```bash
docker push username/admintaskmanager:1.0.0
docker push username/admintaskmanager:latest
```

### 4. Pull and Run from Docker Hub

```bash
docker run -p 3001:3001 -p 80:80 --name admin-panel username/admintaskmanager:latest
```

## 🔍 Dockerfile Overview

The Dockerfile uses a **multi-stage build** process:

**Stage 1 - Build:**
- Uses Node 20-alpine (lightweight)
- Installs dependencies
- Builds the React app with Vite

**Stage 2 - Production:**
- Uses Nginx to serve React static files
- Node.js server handles API requests
- Nginx acts as reverse proxy
- Optimized for production deployment

## ⚙️ Configuration

### Environment Variables

Add environment variables in `docker-compose.yml` or when running:

```bash
docker run -e NODE_ENV=production -p 3001:3001 -p 80:80 admintaskmanager:latest
```

### Ports

- **Port 80**: Nginx web server (React app)
- **Port 3001**: Node.js API server

### Custom Nginx Configuration

Edit `nginx.conf` to customize:
- SSL/TLS settings
- Rate limiting
- Additional routes
- Cache policies

## 🔒 Security Best Practices

1. **Use specific versions** in tags: `admintaskmanager:1.0.0` instead of `latest`
2. **Use environment variables** for sensitive data (API keys, database URLs)
3. **Enable HTTPS** in production using Docker with SSL certificates
4. **Use .dockerignore** to exclude unnecessary files
5. **Run containers as non-root** (already configured)
6. **Set resource limits**:

```bash
docker run --memory 512m --cpus 1 admintaskmanager:latest
```

## 📊 Health Checks

The container includes a health check:

```bash
docker ps  # Shows status: healthy / unhealthy
```

## 🐛 Troubleshooting

### Container exits immediately

```bash
docker logs admin-panel
```

### Port already in use

```bash
docker run -p 8080:80 admintaskmanager:latest  # Use different port
```

### Nginx not responding

```bash
docker exec admin-panel nginx -t  # Test Nginx config
```

### Check running processes

```bash
docker exec admin-panel ps aux
```

## 📝 Workflow: GitHub to Docker Hub

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Add Docker configuration"
   git push origin main
   ```

2. **Clone in new environment**
   ```bash
   git clone https://github.com/username/AdminPanel.git
   cd AdminPanel
   ```

3. **Build Docker image**
   ```bash
   docker build -t admintaskmanager:1.0.0 .
   ```

4. **Push to Docker Hub**
   ```bash
   docker login
   docker tag admintaskmanager:1.0.0 username/admintaskmanager:1.0.0
   docker push username/admintaskmanager:1.0.0
   ```

5. **Deploy from Docker Hub**
   ```bash
   docker pull username/admintaskmanager:1.0.0
   docker run -p 80:80 username/admintaskmanager:1.0.0
   ```

## 🚀 CI/CD Pipeline (Optional)

For automatic building and pushing, create `.github/workflows/docker-build.yml`:

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            username/admintaskmanager:latest
            username/admintaskmanager:${{ github.ref_name }}
```

## 📚 Useful Docker Commands

```bash
# View all images
docker images

# View all containers
docker ps -a

# Remove image
docker rmi admintaskmanager:latest

# Remove container
docker rm admin-panel

# Build with no cache
docker build --no-cache -t admintaskmanager:latest .

# Inspect image
docker inspect admintaskmanager:latest

# Check image size
docker images --format "table {{.Repository}}\t{{.Size}}"
```

## 📞 Support

For issues or questions, check:
- [Docker Documentation](https://docs.docker.com)
- [Docker Hub Documentation](https://docs.docker.com/docker-hub)
- Project README.md

---

**Created for Admin Task Manager Project**
