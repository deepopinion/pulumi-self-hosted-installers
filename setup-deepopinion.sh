#!/usr/bin/env bash

set -e

export PROJECT_NAME=deepopinion
export REGION=europe-west1
export ZONE=europe-west1-b
export COMMON_NAME=do-pulumi
export STACK1=infra
export STACK2=k8s
export STACK3=app
export DB_INSTANCE_TYPE=db-g1-small
export DB_USER=pulumiadmin
export API_DOMAIN=api.pulumi.do-dev.net
export WEB_DOMAIN=web.pulumi.do-dev.net
export LICENSE_KEY="***TODO***"
export IMAGE_TAG=20240130-2248-signed

cd gke-hosted



# Deploy infrastructure

cd 01-infrastructure

npm install

pulumi stack init organization/01-infrastructure-selfhosted-gke/$STACK1
pulumi config set gcp:project $PROJECT_NAME
pulumi config set gcp:region $REGION
pulumi config set gcp:zone $ZONE
pulumi config set commonName $COMMON_NAME
pulumi config set dbInstanceType $DB_INSTANCE_TYPE
pulumi config set dbUser $DB_USER
pulumi up

cd ..



# Deploy GKE cluster

cd 02-kubernetes

npm install

pulumi stack init organization/02-kubernetes-selfhosted-gke/$STACK2
pulumi config set gcp:project $PROJECT_NAME
pulumi config set gcp:region $REGION
pulumi config set gcp:zone $ZONE
pulumi config set stackName1 organization/01-infrastructure-selfhosted-gke/$STACK1
pulumi config set commonName $COMMON_NAME
pulumi config set clusterVersion 1.28
pulumi up

cd ..



# Deploy the application

cd 03-application

npm install

pulumi stack init organization/03-application-selfhosted-gke/$STACK3
pulumi config set stackName1 organization/01-infrastructure-selfhosted-gke/$STACK1
pulumi config set stackName2 organization/02-kubernetes-selfhosted-gke/$STACK2
