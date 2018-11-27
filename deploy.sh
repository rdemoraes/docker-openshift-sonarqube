#!/bin/bash
oc adm new-project --node-selector=region=<region_value> citools-sonarqube
oc project citools-sonarqube
oc new-app -f sonarqube-template.yaml
oc secrets add serviceaccount/builder secrets/sonarqube-ssh
oc adm policy add-scc-to-user privileged -z default
