#!/bin/bash
set -e

VERSION="0.0.1-alpha"
NOTES="Latest ALpha Release before Official Release"

echo "🚀 Finishing Release for $VERSION..."

# 8. Package Artifacts
echo "📦 Packaging Remaining Artifacts..."
if [ -d "build/linux/x64/release/bundle" ]; then
    zip -r builds/kebap-linux-$VERSION.zip build/linux/x64/release/bundle
else
    echo "❌ Error: Linux build bundle not found!"
    exit 1
fi

# Deb
mkdir -p builds/deb/DEBIAN
mkdir -p builds/deb/opt/kebap
mkdir -p builds/deb/usr/share/applications
mkdir -p builds/deb/usr/share/icons/hicolor/scalable/apps
cat > builds/deb/DEBIAN/control << EOL
Package: kebap
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Kebap Team <maintainer@example.com>
Description: A simple cross-platform Jellyfin client.
 Kebap is a modern, fast, and beautiful Jellyfin client.
EOL
cat > builds/deb/usr/share/applications/kebap.desktop << EOL
[Desktop Entry]
Name=Kebap
Comment=A simple cross-platform Jellyfin client
Exec=/opt/kebap/Kebap
Icon=kebap
Terminal=false
Type=Application
Categories=AudioVideo;Video;Player;
EOL
cp -r build/linux/x64/release/bundle/* builds/deb/opt/kebap/
cp icons/kebap_icon.svg builds/deb/usr/share/icons/hicolor/scalable/apps/kebap.svg
dpkg-deb --build builds/deb builds/kebap_${VERSION}_amd64.deb
rm -rf builds/deb

# Web Zip
if [ -d "build/web" ]; then
    zip -r builds/kebap-web-$VERSION.zip build/web
else
    echo "⚠️ Web build not found, skipping web zip."
fi

# 9. Documentation
echo "📝 Generating Documentation..."
DOCKER_USER="j4ckgrey"
# README
cat > builds/README.md << EOL
# Kebap Release $VERSION

## Artifacts
- \`kebap-linux-$VERSION.zip\`: Linux executable bundle.
- \`kebap_${VERSION}_amd64.deb\`: Linux installer (.deb).
- \`kebap-web-$VERSION.zip\`: Web build (PWA).
- \`kebap-docker-$VERSION-*.tar\`: Docker images for AMD64, ARM64, ARMv7.
- \`app-*-signed.apk\`: Android APKs.
- \`kebap_setup_x64.exe\`: Windows Installer.
- \`web/\`: Unzipped web build for direct hosting.

## Docker Images
- **Docker Hub**: \`$DOCKER_USER/kebap:$VERSION\`
- **GHCR**: \`ghcr.io/$DOCKER_USER/kebap:$VERSION\`

## Instructions
(See previous README for installation instructions)
EOL

# 10. Git Release
echo "🐙 Pushing Source Code Release..."
git add .
git commit -m "Release $VERSION" || echo "Nothing to commit"
git tag -f "v$VERSION"
git push origin HEAD
git push -f origin "v$VERSION"

# 11. Web Repo Push (Persistent)
echo "🌐 Pushing Web Build to kebap-web..."
if [ -d "builds/kebap-web" ]; then
    echo "   - Updating existing repo..."
    # Clean old files but keep .git
    find builds/kebap-web -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
    # Copy new build
    cp -r build/web/* builds/kebap-web/
    # Commit and Push
    cd builds/kebap-web
    git add .
    git commit -m "Release $VERSION"
    git push origin master
    cd ../..
else
    echo "⚠️ 'builds/kebap-web' not found. Skipping web repo push."
    echo "   To enable this, clone your web repo into 'builds/kebap-web' before running this script."
fi

# 12. GitHub Release
if command -v gh &> /dev/null; then
    echo "🚀 Creating GitHub Release v$VERSION..."
    # Check if release exists and delete it if so (to allow re-run)
    gh release delete "v$VERSION" -y || true
    gh release create "v$VERSION" \
        --title "Kebap $VERSION" \
        --notes "$NOTES" \
        builds/kebap-linux-*.zip \
        builds/kebap_*.deb \
        builds/kebap-web-*.zip \
        builds/*-signed.apk \
        builds/kebap_setup_x64.exe
else
    echo "⚠️ 'gh' CLI not found. Please upload artifacts manually."
fi

echo "✅ Release Process Complete!"
