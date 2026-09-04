.PHONY: build test image deploy

TAG ?= latest

build:
	docker build -t app-service:$(TAG) .

test: build
	docker rm -f test 2>/dev/null || true
	docker run -d --name test -p 8080:8080 app-service:$(TAG)
	curl --fail --retry 10 --retry-delay 5 --retry-connrefused http://127.0.0.1:8080/healthz
	docker rm -f test

image:
	docker build -t app-service:$(TAG) .

deploy: image
	@echo "Deploying app-service:$(TAG) to $(ENV) environment..."
