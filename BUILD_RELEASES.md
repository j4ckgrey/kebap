Build artifacts and signed release notes

This document explains where build artifacts are produced locally and how to generate signed macOS/iOS builds via CI.

Local artifacts (already produced on this Linux host):

- Linux (release): `build/linux/x64/release/bundle/Kebap`
- Android APKs (production flavor, per-ABI):
  - `build/app/outputs/flutter-apk/app-arm64-v8a-production-release.apk`
  - `build/app/outputs/flutter-apk/app-armeabi-v7a-production-release.apk`
  - `build/app/outputs/flutter-apk/app-x86_64-production-release.apk`
- Android AAB (production flavor):
  - `build/app/outputs/bundle/productionRelease/app-production-release.aab`

Notes on Android signing performed locally:
- A temporary keystore was generated at `android/app/keystore.jks` with alias `kebap_release` and password `kebap_temp_pw_2025`.
- This keystore is suitable for testing but NOT recommended for Play Store distribution. For Play Store releases, use your canonical keystore and protect passwords as secrets.

How to produce Play Store / App Store installers (recommended via CI):

1) Android (Play Store)
  - Add your keystore as a base64 secret (e.g. `KEYSTORE_BASE_64`) and set these repo secrets:
    - `RELEASE_KEYSTORE_PASSWORD`
    - `RELEASE_KEY_PASSWORD`
    - `RELEASE_KEYSTORE_ALIAS`
  - The existing GitHub Actions workflow `Build Kebap` already decodes `KEYSTORE_BASE_64` and creates `android/app/keystore.jks` and `android/app/key.properties`.
  - Trigger the workflow (via tag or manual dispatch) to produce signed APK/AAB artifacts.

2) iOS and macOS (Apple devices)
  - Building signed iOS and macOS artifacts requires macOS runners and Apple signing credentials.
  - A template workflow was added at `.github/workflows/sign-macos-ios.yml`. It expects these secrets (examples):
    - `APPLE_SIGN_CERT_P12_BASE64` (base64 of a P12 signing cert)
    - `APPLE_SIGN_CERT_P12_PASSWORD`
    - `APP_STORE_CONNECT_API_KEY` and `APP_STORE_CONNECT_API_ISSUER` (for notarization with `notarytool`), or set up `APPLE_ID` / `APP_SPECIFIC_PASSWORD` for older `altool` flows.
    - `APPLE_MAC_SIGN_IDENTITY` and `APPLE_IOS_SIGN_IDENTITY` (common names of the certificates to use for codesign)
  - The `Build Kebap` workflow already creates unsigned macOS DMG and iOS IPA artifacts and uploads them; the new signing workflow downloads those and contains placeholders for signing and notarization commands. You should adapt the placeholder commands to your signing stack.

Local commands (examples)

Android (local, temporary keystore):
```bash
cd /path/to/kebap
# Build APKs (per-ABI)
flutter build apk --release --flavor production --split-per-abi
# Build AAB
flutter build appbundle --release --flavor production
```

macOS (must run on macOS machine / runner):
```bash
flutter build macos --release --flavor production
./scripts/create_dmg.sh
```

iOS (must run on macOS machine / runner with signing configured):
```bash
flutter build ipa --export-options-plist=ExportOptions.plist --flavor production --release
```

If you want, I can:
- Replace the temporary keystore with your real keystore (if you provide it), then rebuild Android and overwrite artifacts.
- Customize the `.github/workflows/sign-macos-ios.yml` workflow to perform exact codesign and notarization steps (I will need details about your Apple signing method).

Contact me which option you prefer and I will proceed.
