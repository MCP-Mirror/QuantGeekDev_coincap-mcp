# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install any needed packages specified in package.json
RUN npm install --ignore-scripts

# Copy the current directory contents into the container at /app
COPY . .

# Build the app
RUN npm run build

# Use a smaller node image for the release
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built files from the builder
COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the application
ENTRYPOINT ["node", "build/index.js"]
