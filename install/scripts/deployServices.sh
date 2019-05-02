#!/bin/bash
REGISTRY_URI=$1

export JENKINS_USER=$(cat creds.json | jq -r '.jenkinsUser')
export JENKINS_PASSWORD=$(cat creds.json | jq -r '.jenkinsPassword')
export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat creds.json | jq -r '.githubPersonalAccessToken')
export GITHUB_USER_NAME=$(cat creds.json | jq -r '.githubUserName')
export GITHUB_USER_EMAIL=$(cat creds.json | jq -r '.githubUserEmail')
export DT_TENANT_ID=$(cat creds_dt.json | jq -r '.dynatraceTenant')
export DT_API_TOKEN=$(cat creds_dt.json | jq -r '.dynatraceApiToken')
export DT_PAAS_TOKEN=$(cat creds_dt.json | jq -r '.dynatracePaaSToken')
export GITHUB_ORGANIZATION=$(cat creds.json | jq -r '.githubOrg')
export DT_TENANT_URL="$DT_TENANT_ID.live.dynatrace.com"

rm -rf keptn-services
mkdir keptn-services
cd keptn-services

git clone --branch release-0.1.x https://github.com/keptn/jenkins-service.git --single-branch
cd jenkins-service
chmod +x deploy.sh
./deploy.sh $REGISTRY_URI $JENKINS_USER $JENKINS_PASSWORD $GITHUB_USER_EMAIL $GITHUB_ORGANIZATION $GITHUB_PERSONAL_ACCESS_TOKEN $DT_API_TOKEN $DT_TENANT_URL
cd ..

git clone --branch release-0.1.x https://github.com/keptn/github-service.git --single-branch
cd github-service
chmod +x deploy.sh
./deploy.sh $REGISTRY_URI
cd ..

git clone --branch 0.1.0 https://github.com/keptn/servicenow-service.git --single-branch
cd servicenow-service
chmod +x deploy.sh
./deploy.sh
cd ..

git clone --branch 0.1.0 https://github.com/keptn/pitometer-service.git --single-branch
cd pitometer-service
chmod +x deploy.sh
./deploy.sh
cd ..
