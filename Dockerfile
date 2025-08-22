# Use nginx to serve the static files
FROM nginx:alpine

# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy React build folder to nginx
COPY build /usr/share/nginx/html

# Custom nginx config (optional but recommended for SPA routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
