cd ..
docker build -t jolie_website -f docker/Dockerfile.local . 
docker run -it --rm -p 8080:8080 jolie_website
