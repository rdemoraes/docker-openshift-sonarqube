#!/bin/bash
export VERSION=7.3
docker build -f Dockerfile . -t rdemoraes/sonarqube:${VERSION}
docker tag rdemoraes/sonarqube:${VERSION} rdemoraes/sonarqube:latest
docker push rdemoraes/sonarqube:${VERSION}
docker push rdemoraes/sonarqube:latest
