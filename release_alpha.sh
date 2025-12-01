#!/bin/bash
set -e

echo "🚀 Starting Kebap Alpha Release Process..."

# 1. Clean
echo "🧹 Cleaning project..."
flutter clean
rm -rf builds
mkdir -p builds

# 2. Build Web
echo "🌐 Building Web..."
flutter build web --release --base-href "/"

# 3. Build Linux
echo "🐧 Building Linux (x64)..."
flutter build linux --release

# 4. Build Docker (Multi-arch)
echo "🐳 Building Docker Images..."
# Ensure builder exists
if ! docker buildx inspect kebap_builder > /dev/null 2>&1; then
    echo "Creating Docker builder..."
    docker buildx create --name kebap_builder --use
fi
docker buildx inspect --bootstrap

# Build and Save AMD64
echo "   - Building AMD64..."
docker buildx build --platform linux/amd64 -t kebap:alpha-amd64 --load .
docker save -o builds/kebap-docker-alpha-amd64.tar kebap:alpha-amd64

# Build and Save ARM64
echo "   - Building ARM64..."
docker buildx build --platform linux/arm64 -t kebap:alpha-arm64 --load .
docker save -o builds/kebap-docker-alpha-arm64.tar kebap:alpha-arm64

# Build and Save ARMv7
echo "   - Building ARMv7..."
docker buildx build --platform linux/arm/v7 -t kebap:alpha-armv7 --load .
docker save -o builds/kebap-docker-alpha-armv7.tar kebap:alpha-armv7

# 5. Package Artifacts
echo "📦 Packaging Artifacts..."

# Linux Zip
echo "   - Zipping Linux build..."
zip -r builds/kebap-linux-alpha.zip build/linux/x64/release/bundle

# Linux Deb
echo "   - Creating .deb package..."
mkdir -p builds/deb/DEBIAN
mkdir -p builds/deb/opt/kebap
mkdir -p builds/deb/usr/share/applications
mkdir -p builds/deb/usr/share/icons/hicolor/scalable/apps

# Control File
cat > builds/deb/DEBIAN/control << EOL
Package: kebap
Version: 0.8.0-alpha
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Kebap Team <maintainer@example.com>
Description: A simple cross-platform Jellyfin client.
 Kebap is a modern, fast, and beautiful Jellyfin client.
EOL

# Desktop Entry
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

# Copy Files
cp -r build/linux/x64/release/bundle/* builds/deb/opt/kebap/
cp icons/kebap_icon.svg builds/deb/usr/share/icons/hicolor/scalable/apps/kebap.svg

# Build Deb
dpkg-deb --build builds/deb builds/kebap_0.8.0-alpha_amd64.deb
rm -rf builds/deb

# Web Zip and Folder
echo "   - Packaging Web build..."
cp -r build/web builds/web
zip -r builds/kebap-web-alpha.zip build/web

# 6. Documentation & Scripts
echo "📝 Generating Documentation & Scripts..."

# Publish Docker Script
cat > builds/publish_docker.sh << 'EOL'
#!/bin/bash
set -e
echo "Kebap Docker Publisher"
read -p "Enter Docker Hub Username: " USERNAME
if [ -z "$USERNAME" ]; then echo "Username cannot be empty."; exit 1; fi
VERSION="alpha"
echo "Loading images..."
docker load -i kebap-docker-alpha-amd64.tar
docker load -i kebap-docker-alpha-arm64.tar
docker load -i kebap-docker-alpha-armv7.tar

echo "Pushing images to Docker Hub..."
for ARCH in amd64 arm64 armv7; do
  docker tag kebap:alpha-$ARCH $USERNAME/kebap:$VERSION-$ARCH
  docker push $USERNAME/kebap:$VERSION-$ARCH
done
echo "Creating Docker Hub Manifest..."
docker manifest create $USERNAME/kebap:$VERSION \
    $USERNAME/kebap:$VERSION-amd64 \
    $USERNAME/kebap:$VERSION-arm64 \
    $USERNAME/kebap:$VERSION-armv7
docker manifest push $USERNAME/kebap:$VERSION

echo "Pushing images to GHCR..."
GHCR_IMAGE="ghcr.io/$USERNAME/kebap"
for ARCH in amd64 arm64 armv7; do
  docker tag kebap:alpha-$ARCH $GHCR_IMAGE:$VERSION-$ARCH
  docker push $GHCR_IMAGE:$VERSION-$ARCH
done
echo "Creating GHCR Manifest..."
docker manifest create $GHCR_IMAGE:$VERSION \
    $GHCR_IMAGE:$VERSION-amd64 \
    $GHCR_IMAGE:$VERSION-arm64 \
    $GHCR_IMAGE:$VERSION-armv7
docker manifest push $GHCR_IMAGE:$VERSION

echo "Done! Published to Docker Hub and GHCR."
EOL
chmod +x builds/publish_docker.sh

# README
cat > builds/README.md << 'EOL'
# Kebap Alpha Release (0.8.0-alpha+1)

## Artifacts
- `kebap-linux-alpha.zip`: Linux executable bundle.
- `kebap_0.8.0-alpha_amd64.deb`: Linux installer (.deb).
- `kebap-web-alpha.zip`: Web build (PWA).
- `kebap-docker-alpha-*.tar`: Docker images for AMD64, ARM64, ARMv7.
- `web/`: Unzipped web build for direct hosting.

## Instructions

### Linux
**Option 1: Installer (.deb)**
1. Install the package:
   ```bash
   sudo dpkg -i kebap_0.8.0-alpha_amd64.deb
   ```
   (If there are missing dependencies, run `sudo apt-get install -f`)
2. Run `Kebap` from your application menu or terminal.

**Option 2: Portable Zip**
1. Extract `kebap-linux-alpha.zip`.
2. Run `./Kebap` from the extracted folder.

### Web (PWA)
**Deploy to Vercel (Recommended)**
1. Create a new repository on GitHub (e.g., `kebap-web`).
2. Push the pre-built web folder:
   ```bash
   cd web
   git init
   git add .
   git commit -m "Initial Alpha Release"
   git remote add origin https://github.com/YOUR_USERNAME/kebap-web.git
   git push -u origin master
   ```
3. Import this repository in Vercel. It will automatically detect the static site.

**Run Locally**
- Use any static file server, e.g., `python3 -m http.server` inside the `web` folder.

### Docker
**Option 1: Load from Tar**
Choose the file matching your architecture:
- **x86_64 / AMD64**: `kebap-docker-alpha-amd64.tar`
- **ARM64 (Raspberry Pi 4/5, Apple Silicon)**: `kebap-docker-alpha-arm64.tar`
- **ARMv7 (Older Pi)**: `kebap-docker-alpha-armv7.tar`

1. Load the image:
   ```bash
   docker load -i kebap-docker-alpha-amd64.tar
   # OR
   docker load -i kebap-docker-alpha-arm64.tar
   ```
2. Run the container:
   ```bash
   # The image tag depends on what you loaded, but they are all tagged as kebap:alpha-<arch>
   # Check 'docker images' to see the exact tag.
   # For example:
   docker run -d -p 80:80 kebap:alpha-amd64
   ```

**Option 2: Pull from Registry**
- **Docker Hub**: `docker pull YOUR_USERNAME/kebap:alpha`
- **GHCR**: `docker pull ghcr.io/YOUR_USERNAME/kebap:alpha`

### Linux (ARM/32-bit)
**Note**: The provided Linux installer (`.deb`) is for **x86_64 (AMD64)** only.
For ARM devices (Raspberry Pi, etc.), please use the **Docker** method above, which fully supports ARM64 and ARMv7.
EOL

# 7. Git Release (Source Code)
echo "🐙 Pushing Source Code Release..."
git add .
git commit -m "Release Alpha 0.8.0-alpha+1" || echo "Nothing to commit"
git tag -f v0.8.0-alpha+1
git push origin HEAD
git push -f origin v0.8.0-alpha+1

# 8. Web Repo Push
echo "🌐 Pushing Web Build to kebap-web..."
cd builds/web
git init
git add .
git commit -m "Release Alpha 0.8.0-alpha+1"
git remote add origin git@github.com:j4ckgrey/kebap-web.git
git push -f origin master
cd ../..

# 9. GitHub Release Upload (if gh installed)
if command -v gh &> /dev/null; then
    echo "🚀 Creating GitHub Release and Uploading Artifacts..."
    gh release create v0.8.0-alpha+1 \
        --title "Kebap Alpha 0.8.0-alpha+1" \
        --notes "Alpha release with Web, Linux, and Docker support." \
        builds/kebap-linux-alpha.zip \
        builds/kebap_0.8.0-alpha_amd64.deb \
        builds/kebap-web-alpha.zip \
        builds/kebap-docker-alpha-amd64.tar \
        builds/kebap-docker-alpha-arm64.tar \
        builds/kebap-docker-alpha-armv7.tar
else
    echo "⚠️ 'gh' CLI not found. Please upload artifacts manually:"
    echo "gh release create v0.8.0-alpha+1 builds/*"
fi

echo "✅ Release Process Complete!"
echo "Artifacts are in 'builds/'."
