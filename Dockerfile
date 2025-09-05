FROM node:18-alpine AS builder
WORKDIR /app

# install deps
COPY package*.json ./
RUN npm ci

# copy source and build
COPY . .
RUN npm run build

# ---- serve with nginx ----
FROM nginx:1.27.0-alpine3.19
WORKDIR /usr/share/nginx/html

# copy build output
COPY --from=builder /app/build ./

# replace default config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
