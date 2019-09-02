#!/bin/bash
set -e;

main() {
    # check if all the requird environment variables 
    # are present or not
    check_for_env_variables;
    
}

check_for_env_variables() {
    if [ -z "$WERCKER_HEROKU_DOCKER_DEPLOY_APP_NAME"]; then
        fail "app-name is missing it is required by heroku-docker-deploy step";
    fi

    if [ -z "$WERCKER_HEROKU_DOCKER_DEPLOY_USER"]; then
        fail "user is missing it is reuired by heroku-docker-deploy step";
    fi

    if [ -z "$WERCKER_HEROKU_DOCKER_DEPLOY_ACCESS_KEY"]; then
        fail "access-key is missing it is reuired by heroku-docker-deploy step";
    fi

    if [ -z "$WERCKER_HEROKU_DOCKER_DEPLOY_SSH_KEY_NAME"]; then
        fail "ssh-key-name is missing it is reuired by heroku-docker-deploy step";
    fi
}

main;
