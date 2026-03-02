# Used to transfer the files to the EFS storage
FROM alpine

RUN apk add --no-cache rsync

RUN addgroup --gid 1000 appgroup && adduser -S appuser -G appgroup --uid 1000

WORKDIR /app

COPY --chown=appuser:appgroup . .

USER appuser
