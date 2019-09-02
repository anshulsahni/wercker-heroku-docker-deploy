#!/bin/bash
set -e;

main() {
    # check if all the requird environment variables 
    # are present or not
    check_for_env_variables;

    # this is require to start the docker service
    install_openrc;

    install_docker;

    check_if_heroku_present;

    init_netrc;

    deploy_app_to_heroku;    
    
}

install_openrc() {
    info "Installing openrc package";

    apk add openrc --no-cache;

    info "openrc package installed";
}

install_docker() {
    info "Installing docker";

    apk add docker;

    info "Docker installed with the version: $(docker --version)";

    info "Starting docker service";

    service docker start;

    info "Docker service started";
}

deploy_app_to_heroku() {
    heroku container:push web --app "$WERCKER_HEROKU_DOCKER_DEPLOY_APP_NAME";

    heroku container:release web --app "$WERCKER_HEROKU_DOCKER_DEPLOY_APP_NAME";
}


check_if_heroku_present() {
    info "Checking heroku";
    info "$(heroku --version)";
}

init_netrc() {
    local username="$WERCKER_HEROKU_DOCKER_DEPLOY_USER";
    local password="$WERCKER_HEROKU_DOCKER_DEPLOY_ACCESS_KEY";
    local netrcFile="$HOME/.netrc";

    {
        echo "machine api.heroku.com"
        echo " login $username"
        echo " password $password"
    } >> "$netrcFile";

    chmod 0600 "$netrcFile";

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
