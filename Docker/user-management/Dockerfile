# Stage 1: Build the React app
FROM node:16 AS build

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./
RUN yarn build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 8090

CMD ["nginx", "-g", "daemon off;"]
