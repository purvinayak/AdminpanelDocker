#!/bin/sh
set -e

# Start Nginx in background
nginx -g "daemon off;" &

# Start Node.js server
node server.cjs
