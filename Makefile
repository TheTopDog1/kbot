APP=$(shell basename 'https://github.com/TheTopDog1/kbot')
#REGISTRY=gcr.io/my-project
#REGISTRY=mmmacrosss
REGISTRY=ghcr.io
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64
CGO_ENABLED=0
USER_ID:=thetopdog1
format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${USER_ID}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

build: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/TheTopDog1/kbot/cmd.appVersion=${VERSION}

linux: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=linux GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/TheTopDog1/kbot/cmd.appVersion=${VERSION}

macos: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=darwin GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/TheTopDog1/kbot/cmd.appVersion=${VERSION}

windows: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=windows GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/TheTopDog1/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${USER_ID}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH} --build-arg CGO_ENABLED=${CGO_ENABLED}

push:
	docker push ${REGISTRY}/${USER_ID}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
	echo ">> pushed to ${REGISTRY}/${USER_ID}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}"