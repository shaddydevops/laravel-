# Use Node.js Alpine as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy all files
COPY . .

# Pass env variables
ARG SECRET_COOKIE_PASSWORD
ENV SECRET_COOKIE_PASSWORD=$SECRET_COOKIE_PASSWORD

# Expose the app port
EXPOSE 3000

# Build Next.js app
RUN npm run build

# Start the app test
CMD ["npm", "run", "start"]
