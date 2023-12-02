function awslocal
    set AWS_ACCESS_KEY_ID test
    set AWS_SECRET_ACCESS_KEY test
    set AWS_DEFAULT_REGION $DEFAULT_REGION
    if not set -q DEFAULT_REGION
        set AWS_DEFAULT_REGION $AWS_DEFAULT_REGION
    end
    set host $LOCALSTACK_HOST
    if not set -q LOCALSTACK_HOST
        set host localhost
    end
    aws $argv[1..-1] --endpoint-url=http://$host:4566
end

