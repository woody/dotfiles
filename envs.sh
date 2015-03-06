#!/usr/bin/env bash

# Enable multi-version python, ruby and node envoriments.
enable_multi_version_envs () {
  local envs repo
  envs=(pyenv rbenv nvm)

  for env in ${envs[@]}; do
    case "$env" in
      pyenv)
        repo="https://github.com/yyuu/pyenv.git"
        ;;
      rbenv)
        repo="https://github.com/sstephenson/rbenv.git"
        ;;
      nvm)
        repo="https://github.com/creationix/nvm.git"
        ;;
      *)
        echo "$env not supported yet!" >&2
        return 1
      ;;
    esac

    # Clean brewed installation
    if [[ -d $(brew --cellar $env) ]]; then
      brew remove $env
      brew cleanup --force $env
    fi

    # Is it installed via git?
    if [[ $env = nvm ]]; then
      [ -z "$NVM_DIR" ] && {
        ENV_ROOT=$NVM_DIR
      }
    else
      [[ $(type -P $env) ]] && {
        ENV_ROOT=$(dirname $(dirname $(type -P $env)))
      }
    fi

    [ -z $ENV_ROOT ] && ENV_ROOT=$HOME/.$env
    export ENV_ROOT=$ENV_ROOT

    # Looking for exist local repo
    if [[ -d $ENV_ROOT/.git ]]; then
      cd $ENV_ROOT
    else
      # Installing
      mkdir -p $ENV_ROOT && cd $_
      git init && git remote add origin $repo
    fi

    # Updating
    git pull --quiet origin master

    # Back to original
    cd -

    # Add to PATH
    if [[ $env != nvm ]]; then
      ruby -e 'abort unless ENV["PATH"].split(":").include? \
      "#{ENV["ENV_ROOT"]}/bin"' || export PATH=$ENV_ROOT/bin:$PATH
    fi

    # Clean up
    unset ENV_ROOT

  done

}

enable_multi_version_envs
