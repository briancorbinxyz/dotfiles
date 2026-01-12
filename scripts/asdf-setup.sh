#!/bin/bash
set -e

echo "==> Setting up asdf plugins..."

# Install plugins
asdf plugin add java https://github.com/halcyon/asdf-java.git 2>/dev/null || true
asdf plugin add gradle https://github.com/rfrancis/asdf-gradle.git 2>/dev/null || true
asdf plugin add maven https://github.com/halcyon/asdf-maven.git 2>/dev/null || true
asdf plugin add quarkus https://github.com/asdf-community/asdf-quarkus.git 2>/dev/null || true

echo "==> Installing Java, Gradle, Maven, Quarkus..."
asdf install java latest:temurin-21
asdf install gradle latest
asdf install maven latest
asdf install quarkus latest

echo "==> Setting global versions..."
asdf global java latest:temurin-21
asdf global gradle latest
asdf global maven latest
asdf global quarkus latest

echo ""
echo "==> Done! Installed versions:"
asdf current
