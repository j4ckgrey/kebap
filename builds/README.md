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

**Option 2: Publish to Registry (Easy)**
1. Run the included script to publish all architectures to Docker Hub:
   ```bash
   ./publish_docker.sh
   ```
   (Enter your Docker Hub username when prompted)
2. Users can then pull the multi-arch image:
   ```bash
   docker pull YOUR_USERNAME/kebap:alpha
   ```

### Linux (ARM/32-bit)
**Note**: The provided Linux installer (`.deb`) is for **x86_64 (AMD64)** only.
For ARM devices (Raspberry Pi, etc.), please use the **Docker** method above, which fully supports ARM64 and ARMv7.
