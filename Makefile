.PHONY: build test image deploy
build:
	docker build -t app-service .
test: build
	docker rm -f test 2>/dev/null || true
	docker run -d --name test -p 8080:8080 app-service
	sleep 5
	curl --fail http://127.0.0.1:8080/healthz
	docker rm -f test
image:
	docker build -t app-service:$(TAG) .
deploy: image
	@echo "Deploying app-service:$(TAG) to $(ENV) environment..."
