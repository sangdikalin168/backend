# Dockerfile
FROM node:23-alpine

WORKDIR /usr/src/app

# Install dependencies first
COPY package*.json ./

RUN npm install

# Copy source code
COPY . .

RUN npx prisma generate

# Build TypeScript (if needed in container)
RUN npm run build

# Expose port
EXPOSE 4000

# Start server
CMD ["npm", "run", "start"]