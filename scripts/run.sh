#!/bin/sh

docker run -it --rm \
	-v "$(pwd)"/www:/var/lib/leonardo/www \
	-v "$(pwd)"/jolie:/server \
	-w /server/leonardo \
	-p 8080:8080 \
	jolielang/jolie \
	jolie leonardo.ol
