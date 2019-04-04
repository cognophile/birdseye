#!/bin/bash
case $1 in
 -[h] | --help)
    cat <<-helpDoc
    usage: birdseye.sh [ --help ] [ --info ] [ --version ]
        
         This script runs in non-interactive mode, with no arguments. 
         Simply ensure your current directory is a git initialised directory.
         -h | --help 	: Display this help message.
         -i | --info 	: Display important information about this script.
         -v | --version : Display the version number of this script.
	helpDoc
        exit 0;;
esac
case $1 in
 -[i] | --info)
    cat <<-infoDoc
------------------------------------ birdseye ------------------------------------
         Get a summary of the currently open git repository.
         
		 Licensed under the MIT License (MIT)
         Copyright (c) 2019 cognophile (https://github.com/cognophile)
         To display help, use the '-h' or '--help' option.
------------------------------------ birdseye ------------------------------------
	infoDoc
        exit 0;;
esac
case $1 in
 -[v] | --version)
    cat <<-versionDoc
    birdseye version: 1.0.0
	versionDoc
        exit 0;;
esac

function bootstrap {
    local hour=$(date '+%H')
    local period=''
    local user="${USER}"

    if [ $hour -lt 12 ]; then
        period='morning'
    elif [ $hour -gt 12 ] && [ $hour -lt 18 ]; then
        period='afternoon'
    else
        period='evening'
    fi

    printf "\n$(tput setaf 7)Good $period, $(tput setaf 1)$user!$(tput setaf 7)\n"
}

function getHead {
    local head=$(git rev-parse --short HEAD)
    local branch=$(git branch | grep \* | cut -d ' ' -f2)

    local result="$head of $branch"
    echo "$result"
}

function getRemoteOrigin {
    local remote=$(git config --get remote.origin.url)

    local result="$remote"
    echo "$result"
}

function getLogSummary {
    printf "The latest commits are: \n"
    for i in "$(git log --oneline -8 --decorate)"
    do
        printf "$(tput setaf 6)$i $(tput setaf 7)\n"
    done
}

function getGitUser {
    local gitUser=$(git config user.name)
    local gitEmail=$(git config user.email)

    local result="$gitUser ($gitEmail)"
    echo "$result"
}

function getUserProgress {
    local gitUser=$(git config user.name)

    printf "\nYesterday, you: \n"
    for i in "$(git log --oneline -8 --decorate --author $gitUser --since=yesterday.midnight)"
    do
        printf "$(tput setaf 6)$i $(tput setaf 7)\n"
    done
}

function getStash {
    if [[ $(git stash list | wc -l) -eq 0 ]]; then
        printf "\nYour stash is empty - nice!\n"
    else
        printf "\nIn your stash: \n"
        for i in "$(git stash list)"
        do
            printf "$(tput setaf 5)$i $(tput setaf 7)\n"
        done
    fi
}

function renderLogs {
   getLogSummary
   getUserProgress
   getStash
}

function renderHeader {
    local user="$(tput setaf 7)Your git user is $(tput setaf 2)$1 $(tput setaf 7)"
    local project="$(tput setaf 7)Your $(tput setaf 3)$2 $(tput setaf 7)project is looking great!"
    local branch="$(tput setaf 7)You're at $(tput setaf 3)$3 $(tput setaf 7)"
    local origin="$(tput setaf 7)The remote is $(tput setaf 3)$4 $(tput setaf 7)"
    
    local result="\n$user \n$project \n$branch \n$origin \n\n"
    printf "$result" 
}

function execute {
    local user=$(getGitUser)
    local project=$(basename $PWD)
    local head=$(getHead)
    local origin=$(getRemoteOrigin)

    renderHeader "$user" "$project" "$head" "$origin" 
    renderLogs
} 

# Execution point
if [[ ! -d .git ]]; then
	printf "\n$(tput setaf 1)Rut-roh! $(tput setaf 7)You appear not to be in a git directory :(\n"
	exit 1
else
	bootstrap "$1"
    execute
fi