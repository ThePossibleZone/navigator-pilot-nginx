# Clone the private Github repos using SSH 
# Run the docker compose build command
# Run the docker compose up command to start the containers

rm -rf ./repos
mkdir -p ./repos

git clone git@github-navigator-api:ThePossibleZone/navigator-api.git ./repos/navigator-api
git clone git@github-navigator-web:ThePossibleZone/navigator-web.git ./repos/navigator-web
git clone git@github-navigator-shared:ThePossibleZone/navigator-shared.git ./repos/navigator-shared

docker compose down
docker compose build --no-cache
docker compose up -d