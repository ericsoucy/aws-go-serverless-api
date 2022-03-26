# Go and AWS - Code and Deploy a Serverless API

Based on <https://www.youtube.com/watch?v=zHcef4eHOc8&t=20s>

## GoLang

```bash
go mod init github.com/ericsoucy/aws-go-serverless-api
...
go mod tidy

go build -v main.go
cp main ./build
```

```bash
// prepare zip file
zip -jrm build/main.zip build/main
```


## Running localstack

```bash
// run localstack
podman run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack

// to use network host
podman run --rm -it -p 4566:4566 -p 4571:4571 --network host localstack/localstack

// to make this run lambda that calls dynamodb
podman run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack -e DEFAULT_REGION=ca-central-1 -e AWS_DEFAULT_REGION=ca-central-1 -e AWS_SECRET_ACCESS_KEY = "test" -e AWS_ACCESS_KEY_ID = "test"

//check
curl http://localhost:4566/health | jq
```

## Terraform with local stack

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/custom-service-endpoints#localstack>

<https://docs.localstack.cloud/integrations/terraform/>

<https://dev.to/mrwormhole/localstack-with-terraform-and-docker-for-running-aws-locally-3a6d>

```bash
cd infra-as-code
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

aws --endpoint-url=http://localhost:4566 lambda list-functions --profile local

aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis --profile local

aws --endpoint-url=http://localhost:4566 apigateway get-rest-api --rest-api-id ns241xb2xd --profile local

aws --endpoint-url=http://localhost:4566 apigateway get-deployments --rest-api-id ns241xb2xd --profile local

aws --endpoint-url=http://localhost:4566 apigateway get-deployment --rest-api-id ns241xb2xd --deployment-id rs7pmohpi0 --profile local

//***
aws --endpoint-url=http://localhost:4566 apigateway get-resources --rest-api-id ns241xb2xd --profile local


curl -vvvv http://localhost:4566/restapis/ns241xb2xd/test/_user_request_/

curl -vvvv --header "Content-Type: application/json" --request POST --data '{"email": "totot@toto.com", "firstName": "toto", "lastName":"toto"}' http://localhost:4566/restapis/qxkf29gdo8/test/_user_request_/

curl -vvvv http://localhost:4566/restapis/1v1mgbw7pc/test/_user_request_/?email\=toto@toto.com

curl -vvvv --header "Content-Type: application/json" --request PUT --data '{"email": "totot@toto.com", "firstName": "titi", "lastName":"titi"}' http://localhost:4566/restapis/qxkf29gdo8/test/_user_request_/

//dynamodb
aws dynamodb list-tables --endpoint-url=http://localhost:4566 --profile local
aws dynamodb scan --table-name LambdaInGoUser --endpoint-url=http://localhost:4566 --profile local

//logs
aws --endpoint-url=http://localhost:4566 logs describe-log-groups --profile local

aws --endpoint-url=http://localhost:4566 logs describe-log-streams --log-group-name /aws/lambda/go-serverless-api --profile local


 aws --endpoint-url=http://localhost:4566 logs get-log-events --log-group-name /aws/lambda/go-serverless-api --log-stream-name '2022/03/24/[LATEST]e60de935' --profile local
```
