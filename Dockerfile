# Stage 1: Build the application
FROM node:18-alpine as BUILD_IMAGE
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Create the final image
FROM node:18-alpine AS PRODUCTION_IMAGE
WORKDIR /usr/src/app
COPY --from=BUILD_IMAGE /usr/src/app/dist ./dist
EXPOSE 8080
COPY package.json package-lock.json vite.config.js ./
COPY --from=BUILD_IMAGE /usr/src/app/node_modules ./node_modules
EXPOSE 8080
CMD ["npm", "run", "preview"]