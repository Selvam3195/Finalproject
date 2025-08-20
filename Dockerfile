# Use official nginx image
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static files
RUN rm -rf ./*

# Copy build output to nginx html folder
COPY . .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
