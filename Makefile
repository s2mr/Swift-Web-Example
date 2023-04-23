IMAGE=ghcr.io/s2mr/swift-web
port:=1000

build:
	carton bundle
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE) .

build-no-cache:
	docker build -t $(IMAGE) --no-cache .

push:
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

run:
	docker run --name swift-web --rm $(IMAGE)

deploy:
	docker context use default
	make build push
	docker context use conoha
	make pull run
	docker context use default