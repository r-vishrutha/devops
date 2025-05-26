# Use a Node image
FROM node:14

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Build the React app for production
RUN npm run build

# Install 'serve' to serve the build folder
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Serve the app
CMD ["serve", "-s", "build", "-l", "3000"]
