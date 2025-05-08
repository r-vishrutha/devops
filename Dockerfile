# ---------- Stage 1: Build React app ----------
    FROM node:18-alpine AS build

    # Set working directory inside container
    WORKDIR /app
    
    # Copy package.json and package-lock.json (or yarn.lock) and install dependencies
    COPY package*.json ./
    RUN npm install
    
    # Copy the rest of the application code
    COPY . .
    
    # Build the React app for production
    RUN npm run build
    
    # ---------- Stage 2: Serve with Nginx ----------
    FROM nginx:alpine
    
    # Copy built React files from previous stage to Nginx html directory
    COPY --from=build /app/build /usr/share/nginx/html
    
    # Expose port 80 for the container
    EXPOSE 80
    
    # Start Nginx server
    CMD ["nginx", "-g", "daemon off;"]
    