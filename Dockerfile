# Stage 1: Build the Angular application
FROM node:20 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Angular app for production
RUN npm run build --prod

# Stage 2: Serve the Angular application with Nginx
FROM nginx:alpine

# Copy the built files from the previous stage to the Nginx directory
COPY --from=build /app/dist/admin-panel/* /usr/share/nginx/html/

# Expose the port Nginx will run on (default 80)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
