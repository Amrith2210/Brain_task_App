FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
RUN npm run build



FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
# Removing default nginx.conf 
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/app.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
