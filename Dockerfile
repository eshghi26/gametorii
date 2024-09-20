# Stage 1: Serve the Angular application with Nginx
FROM nginx:alpine

# Copy the built files from the previous stage to the Nginx directory
COPY ./dist/game-frontend/* /usr/share/nginx/html/

# Expose the port Nginx will run on (default 80)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
