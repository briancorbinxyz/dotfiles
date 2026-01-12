#!/bin/bash
set -e

# Get latest stable version (excludes RC, SNAPSHOT, milestone, beta, alpha)
latest_stable() {
    asdf list all "$1" | grep -E '^[0-9]+\.[0-9]+(\.[0-9]+)?$' | tail -1
}

echo "==> Setting up asdf plugins..."

# Install plugins
asdf plugin add java https://github.com/halcyon/asdf-java.git 2>/dev/null || true
asdf plugin add gradle https://github.com/rfrancis/asdf-gradle.git 2>/dev/null || true
asdf plugin add maven https://github.com/halcyon/asdf-maven.git 2>/dev/null || true
asdf plugin add quarkus https://github.com/asdf-community/asdf-quarkus.git 2>/dev/null || true

echo "==> Installing Java, Gradle, Maven, Quarkus..."

# Java uses different versioning
asdf install java latest:temurin-21

# Get latest stable versions for others
GRADLE_VERSION=$(latest_stable gradle)
MAVEN_VERSION=$(latest_stable maven)
QUARKUS_VERSION=$(latest_stable quarkus)

echo "    Gradle: $GRADLE_VERSION"
asdf install gradle "$GRADLE_VERSION"

echo "    Maven: $MAVEN_VERSION"
asdf install maven "$MAVEN_VERSION"

echo "    Quarkus: $QUARKUS_VERSION"
asdf install quarkus "$QUARKUS_VERSION"

echo "==> Setting global versions..."
asdf set --home java latest:temurin-21
asdf set --home gradle "$GRADLE_VERSION"
asdf set --home maven "$MAVEN_VERSION"
asdf set --home quarkus "$QUARKUS_VERSION"

echo ""
echo "==> Done! Installed versions:"
asdf current
