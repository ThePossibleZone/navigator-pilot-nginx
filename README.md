## Hi there!
This README was written by hand with love. Thanks so much for helping us get this online. 

### Deploying
1. Clone this repo into a Linux/Arm64 environment with Docker installed.
```
git clone https://github.com/ThePossibleZone/navigator-pilot-nginx.git
```
2. Generate SSH keys for the host machine. This also creates a `~/.ssh/config` file with host aliases. Nota bene, you'll need to register the public keys as deploy keys in three of our repos on Github.com: `navigator-api`, `navigator-web`, and `navigator-shared`
```
sh generate_ssh_keys.sh
```

4. Add the .env.* files. These can be provided over Slack or via thumbdrive, just ask!

5. Run the deploy script. It will pull the necessary repos, build, and deploy all services
```
sh deploy.sh
```
6. If this is a fresh deployment, seed the db.
```
sh seed.sh
```

### Updating
`deploy.sh` pulls from our git repositories and restarts the docker containers, so that's a fast way to update the deployment with new patches:
```
sh deploy.sh
```

## How do we talk to the app?
Nginx exposes several HTTP locations on port 80:
- `/`             The React app (Vite)
- `/api/v1`       General api endpoints (AdonisJS)
- `/__transmit`   SSE endpoints (AdonisJS)
- `/auth`         Authentication endpoints (AdonisJS)

I'm hoping that's flexible enough to be plugged into your preferred deployment scheme.

## What's in here?
Check out `docker-compose.yaml` to see the specifics. In launch order...
- PostgreSQL 17 with pgvector
- Letta AI, a stateful ai agent microservice
- A helper which registers Letta's tools
- AdonisJS backend serving most of the app's endpoints
- Vite app, serving the frontend React app
- Nginx reverse proxy

## Where is student data stored?
There are two folders to keep an eye on. It would be great if we can set up daily or weekly backups of these stores, or the whole machine instance 🙏.
- `pgdata` -> Persists the PostgreSQL database, holds profiles, reflections, artifacts, AI conversations, skills & trees, etc.
- `uploads` -> Any files which users upload for artifacts / galleries