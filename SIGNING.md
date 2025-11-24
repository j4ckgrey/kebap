Signing guide — create Apple secrets and run CI

This guide shows how to export the signing files from a Mac, encode them, add them as GitHub secrets, and trigger the automated signing workflow added to this repo.

1) Export your P12 (certificate + private key) from your Mac

- Open **Keychain Access**.
- Find the certificate you want to export (e.g. **Apple Distribution: Your Name (TEAMID)** or **Developer ID Application: ...**).
- Right-click the certificate → **Export**. Choose **.p12** format and set a password when exporting. Save as `cert.p12`.

2) Download App Store Connect API Key (.p8)

- Go to App Store Connect → Users and Access → Keys.
- Create a new API key (give it a name), assign the needed role (App Manager or as required), and download the `.p8` file (it will be named like `AuthKey_ABC123.p8`).

3) (Optional) Download provisioning profile for iOS

- On the Apple Developer portal, create/download an App Store provisioning profile for your App ID, and save it as `profile.mobileprovision`.

4) Prepare base64 encodings (easy method)

Run the helper script included in this repo which will generate `.base64` files next to it:

```bash
cd /path/to/kebap/scripts
./prepare_signing.sh
```

This will produce files like:
- `cert.p12.base64`
- `AuthKey_XXX.p8.base64` (if present)
- `profile.mobileprovision.base64` (if present)

5) Add GitHub Secrets (via web UI or `gh` CLI)

Recommended secret names (used by the workflow in `.github/workflows/sign-macos-ios.yml`):

- `APPLE_SIGN_CERT_P12_BASE64` — value: contents of `cert.p12.base64`
- `APPLE_SIGN_CERT_P12_PASSWORD` — the password you set when exporting the p12
- `APPLE_MAC_SIGN_IDENTITY` — e.g. `Developer ID Application: Your Name (TEAMID)` (string)
- `APPLE_IOS_SIGN_IDENTITY` — e.g. `Apple Distribution: Your Name (TEAMID)` (string)
- `APP_STORE_CONNECT_API_KEY` — contents of `AuthKey_XXX.p8.base64` (or raw `.p8` text)
- `APP_STORE_CONNECT_API_KEY_ID` — the Key ID shown in App Store Connect (string)
- `APP_STORE_CONNECT_API_ISSUER` — the Issuer ID shown in App Store Connect (string)
- `MOBILEPROVISION_BASE64` — contents of `profile.mobileprovision.base64` (optional)
- `APP_BUNDLE_ID` — your app's bundle id (e.g. `nl.jknaapen.kebap`)

Using `gh` CLI (example):

```bash
# Install gh and authenticate first
gh secret set APPLE_SIGN_CERT_P12_BASE64 --body "$(cat cert.p12.base64)"
gh secret set APPLE_SIGN_CERT_P12_PASSWORD --body "<your-p12-password>"
gh secret set APP_STORE_CONNECT_API_KEY --body "$(cat AuthKey_ABC123.p8.base64)"
gh secret set APP_STORE_CONNECT_API_KEY_ID --body "ABCDE12345"
gh secret set APP_STORE_CONNECT_API_ISSUER --body "<issuer-uuid>"
gh secret set APP_BUNDLE_ID --body "nl.jknaapen.kebap"
```

6) Trigger CI to build and sign

- Go to the Actions tab in GitHub → select **Build Kebap** and click **Run workflow** (choose build type 'release' if needed), or push a tag `vX.Y.Z` to trigger a release build.
- After `Build Kebap` completes successfully, the workflow `Sign macOS and iOS Artifacts` will automatically run (it is configured to run after `Build Kebap` finishes). That workflow will decode the secrets, install the certificate into a temporary keychain, codesign the app, produce a DMG, and attempt notarization and IPA export.

7) Troubleshooting

- If the macOS signing job fails, check the Actions logs for certificate import and codesign errors — common issues are wrong identity string, missing provisioning profile, or incorrect P12 password.
- If notarization fails, ensure `APP_STORE_CONNECT_API_KEY`, `APP_STORE_CONNECT_API_KEY_ID`, and `APP_STORE_CONNECT_API_ISSUER` are correct.

If you want, I can walk you through each step interactively (e.g., telling you exactly what to click in Keychain Access), or I can help set secrets using `gh` if you paste the `.base64` contents here (only if you're comfortable doing that). Otherwise, follow these steps and then trigger the workflow; I will monitor and help debug any CI failures.
