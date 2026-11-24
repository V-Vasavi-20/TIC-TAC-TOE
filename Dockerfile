# ---------- Stage 1: Build the React app ----------

# Using Node.js 18 (Alpine) as the build image
FROM node:18-alpine AS build

# Setting up the working directory
WORKDIR /app

# Copying the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Installation of npm dependencies
RUN npm install

# Copy the application code
COPY . .

# Building the React app (creates the /app/build folder)
RUN npm run build


# ---------- Stage 2: Serve the app with Nginx ----------

# Using lightweight Nginx (Alpine) as the final image
FROM nginx:alpine

# Copy the built React files from Stage 1 into the Nginx web folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 inside the container
EXPOSE 80

# Start Nginx in the foreground so the container keeps running
CMD ["nginx", "-g", "daemon off;"]
