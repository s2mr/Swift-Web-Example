IMAGE=ghcr.io/s2mr/swift-web
port:=1000

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

run:
	docker run -p $(port):80 --rm $(IMAGE)