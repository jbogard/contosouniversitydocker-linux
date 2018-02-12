docker-compose -f ./docker-compose.ci.yml -p contosouniversitydotnetcore-ci up -d --build --remove-orphans --force-recreate 2>&1

docker-compose -f ./docker-compose.ci.yml -p contosouniversitydotnetcore-ci run ci ./Build.sh
