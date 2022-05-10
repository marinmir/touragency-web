FROM golang:1.16-alpine

WORKDIR /app

COPY main.go .
COPY go.mod .
COPY go.sum .
COPY db ./db
COPY auth ./auth
COPY cache ./cache
COPY api ./api
COPY model ./model

RUN go mod download

RUN go build -o /touragency

EXPOSE 8080

ENTRYPOINT ["/touragency"]