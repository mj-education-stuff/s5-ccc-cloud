# Step 1: Use an official Node.js runtime as a parent image
FROM --platform=linux/amd64 node:18

# Step 2: Set the working directory
WORKDIR /usr/src/app

# Step 3: Copy package.json and package-lock.json
COPY package*.json ./

# Step 4: Install dependencies
RUN npm install

# Step 5: Copy the rest of the application code
COPY . .

# Step 6: Build the application (if necessary, e.g., for TypeScript)
RUN npm run build

# Step 7: Expose the port the app runs on
EXPOSE 3000

# Step 8: Define the command to run the application
CMD ["npm", "start"]