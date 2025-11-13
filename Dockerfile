# Use a small nginx image to serve static files
FROM nginx:1.25-alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy site files into nginx html folder
COPY . /usr/share/nginx/html

# (Optional) If you added a custom nginx.conf, uncomment the next line:
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
