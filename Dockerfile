FROM ibm-semeru-runtimes:open-11-jdk AS builder
WORKDIR /build/Lavalink
COPY . /build
RUN ./gradlew build

FROM ibm-semeru-runtimes:open-11-jre
WORKDIR /app
ENV USER=lavalink
ENV UID=322
RUN useradd -r -u "$UID" "$USER"
RUN apt-get update -qq && apt-get install tini -y && apt-get clean
COPY --from=builder /build/Lavalink/LavalinkServer/build/libs/Lavalink.jar .
USER lavalink
ENTRYPOINT ["/usr/bin/tini", "--", "/opt/java/openjdk/bin/java", "-Djdk.tls.client.protocols=TLSv1.2,TLSv1.3", "-jar", "Lavalink.jar"]
