#!/bin/bash

flutter pub get && flutter run --release -d web-server --web-port 9090 --web-hostname 0.0.0.0