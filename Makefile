.PHONY: test clean

build:
	go build -o bin/main main.go

build-lambda:
	GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o bin/bootstrap main.go

run: build
	bin/main

go-run:
	go run main.go

deps:
	go get

tidy:
	go mod tidy

clean: tidy
	rm -rf bin

test:
	go test -v ./test/...

build-all-platforms:
	echo "Compiling for other platforms"
	GOOS=linux GOARCH=arm go build -o bin/main-linux-arm main.go
	GOOS=linux GOARCH=arm64 go build -o bin/main-linux-arm64 main.go
	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 main.go
	GOOS=windows GOARCH=arm64 go build -o bin/main-windows-arm64 main.go

terraform-init:
	terraform -chdir=terraform init

terraform-validate:
	terraform -chdir=terraform validate

terraform-apply: build-lambda
	terraform -chdir=terraform apply

terraform-destroy:
	terraform -chdir=terraform destroy