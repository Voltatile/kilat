# Dockerfile generik untuk semua service Go.
# Contoh: docker build --build-arg SERVICE=product -t kilat-product .

FROM golang:1.26-alpine AS build
ARG SERVICE
WORKDIR /src

COPY go.mod go.sum* ./
RUN --mount=type=cache,target=/go/pkg/mod go mod download

COPY . .
# Cache mount menyimpan hasil compile antar build, jadi rebuild hanya
# meng-compile ulang package yang berubah.
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/app ./services/${SERVICE}

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /out/app /app
USER nonroot:nonroot
ENTRYPOINT ["/app"]
