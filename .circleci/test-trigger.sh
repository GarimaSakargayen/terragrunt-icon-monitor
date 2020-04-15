set -e

# latest commit
LATEST_COMMIT=$(git rev-parse HEAD)
AWS_COMMIT=$(git log -1 --format=format:%H --full-diff monitor/aws)

if [ $AWS_COMMIT = $LATEST_COMMIT ];
    then
        make test-aws
else
     echo "No target folders have changed"
     exit 0;
fi
