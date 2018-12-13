#!/bin/bash

echo "Build de mytinytodo"
docker build -t gerault/docker-mytinytodo-php5-fpm . --pull
