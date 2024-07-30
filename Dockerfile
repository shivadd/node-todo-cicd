# Node Base Image
FROM node:12.2.0-alpine

# Working Directory
WORKDIR /node

# Copy the Code
COPY . .

# Install the dependencies
RUN npm install

# Run tests
RUN npm run test

# Expose the port
EXPOSE 8000

# Run the code
CMD ["node", "app.js"]
