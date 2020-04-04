$(aws ecr get-login --no-include-email)

docker build . -f Dockerfile_Server -t 866969444757.dkr.ecr.us-east-1.amazonaws.com/coronavirus-server:latest

# Repo needs to exist first before pushing into AWS
docker push 866969444757.dkr.ecr.us-east-1.amazonaws.com/coronavirus-server:latest

# Restarts the service, which makes the task to restart with the latest docker image
aws ecs update-service --cluster coronavirus --service coronavirus --force-new-deployment --desired-count 1