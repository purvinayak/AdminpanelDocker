# Stage 1: Build the React application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve with Nginx
FROM node:20-alpine

WORKDIR /app

# Install nginx
RUN apk add --no-cache nginx

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy package files for backend
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy server files
COPY server.cjs ./
COPY middleware-auth.cjs ./
COPY db.json ./

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 3001 80

# Create a startup script
RUN echo '#!/bin/sh\n\
# Start Nginx in background\n\
nginx -g "daemon off;" &\n\
\n\
# Start Node.js server\n\
node server.cjs\n\
' > /app/start.sh && chmod +x /app/start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/health || exit 1

# Start the application
CMD ["/app/start.sh"]
