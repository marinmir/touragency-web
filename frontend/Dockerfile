FROM ubuntu:20.04 as builder
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
RUN apt-get clean

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"


# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter doctor
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Record the exposed port
EXPOSE 9090

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/app/startup.sh"]

ENTRYPOINT [ "/app/startup.sh"]