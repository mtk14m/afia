# ── Stage 1 : compilation ────────────────────────────────────────────────────
FROM golang:1.26-alpine AS builder
WORKDIR /app

# On copie go.mod et go.sum EN PREMIER.
# Docker met en cache chaque couche. Si le code change mais pas les dépendances,
# Docker réutilise le cache du go mod download — builds beaucoup plus rapides.
COPY go.mod go.sum ./
RUN go mod download

COPY . .

# CGO_ENABLED=0 : binaire statique, zéro dépendance C → fonctionne dans distroless
# GOOS=linux   : on compile pour Linux depuis macOS
# -s -w        : supprime les infos de debug, réduit la taille de ~30%
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /afia-gateway ./cmd/gateway

# ── Stage 2 : runtime ────────────────────────────────────────────────────────
FROM gcr.io/distroless/static-debian12
COPY --from=builder /afia-gateway /afia-gateway
EXPOSE 8080
ENTRYPOINT ["/afia-gateway"]
