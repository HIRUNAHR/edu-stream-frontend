# ---- Build Stage ----
FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code and build
COPY . .
RUN npm run build

# ---- Nginx Stage ----
FROM nginx:1.27.0-alpine3.19
WORKDIR /usr/share/nginx/html

# Copy build output from builder
COPY --from=builder /app/build ./

# Optional: copy custom nginx.conf only if it exists
# Use a default one if you don't have it
# Uncomment below lines if you provide your own nginx.conf
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 3000 (or 80 for default nginx)
EXPOSE 3000

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
