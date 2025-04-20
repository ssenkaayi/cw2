# Use official Node.js base image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy application files
COPY server.js .

# Expose port
EXPOSE 8081

# Run the app
CMD ["node", "server.js"]
