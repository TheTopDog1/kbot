APP=https://github.com/TheTopDog1/kbot
REGISTRY=FooBar
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64
CGO_ENABLED=0

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get§

clean:
	rm -rf kbot

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/TheTopDog1/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}