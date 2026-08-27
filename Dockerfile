FROM eclipse-temurin:21-jdk AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY museme-source-edge-touch.zip /workspace/museme-source-edge-touch.zip
RUN mkdir /workspace/app \
    && unzip -q /workspace/museme-source-edge-touch.zip -d /workspace/app

WORKDIR /workspace/app
RUN chmod +x ./gradlew \
    && ./gradlew :friend-room-server:installDist --no-daemon

FROM eclipse-temurin:21-jre

WORKDIR /app
COPY --from=build /workspace/app/server/friend-room-server/build/install/friend-room-server/ /app/

ENV PORT=10000
EXPOSE 10000

CMD ["/app/bin/friend-room-server"]
