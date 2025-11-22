**Overview**
- **Origin**: This project was forked from `Fladder` (https://github.com/j4ckgrey/Fladder). Replace the placeholders below with your new app name and logo when available.
- **Purpose**: Prep the repo for public GitHub deployment under a new app name — remove/replace references to Fladder, update icons, and create a fresh README and release workflow.

**Immediate To-Do**
- **Replace app name**: update `pubspec.yaml` `name` and any display names in `android` and `ios` manifests.
- **Replace icons**: update launcher icons in `icons/production` and any platform-specific icons under `android/app/src/main/res` and `ios/Runner/Assets.xcassets`.
- **Update packaging metadata**: update `AppImageBuilder.yml`, `flatpak/`, `snap/`, `Dockerfile`, CI workflows and badges in `README.md` that reference `j4ckgrey/Fladder`.
- **Update package identifiers**: (optional) change Android applicationId and iOS bundle id if desired (careful if you publish updates to the Play/App stores).
- **Create/verify signing**: create `android/app/my-release-key.jks` and `android/key.properties` for release signing (or configure signing in CI).

**Files/Locations Known to Contain 'Fladder'**
- `README.md` — marketing images and badges referencing `j4ckgrey/Fladder` and `assets/marketing` screenshots.
- `.vscode/launch.json` — debug profile names (contains "Fladder Development", etc.).
- `AppImageBuilder.yml` — AppImage metadata (`id`, `name`, `exec`, `icon`).
- `flatpak/` — `Fladder.desktop` and `nl.jknaapen.fladder.yaml` with app id and command.
- `icons/production` and `icons/development` — various `fladder_*` icon files.
- `assets/marketing` — screenshots and images that contain the app name or Fladder branding.
- CI / workflow files and badges (search for `j4ckgrey/Fladder` and update to your repo name).

**Non-Destructive Prep Steps I Can Run Now (recommended)**
1. Scan repository for all occurrences of the term `Fladder` and generate a change list (I already scanned; see my report).  
2. Create a new draft `README.md` with placeholder name/logo and a note about origin (I created `README_PREPARE.md`).  
3. Create a replacement script (dry-run mode) that lists/changes files, replacing `Fladder`->`<NEW_NAME>` and updating icons (will not delete `.git` unless you confirm).  

**Destructive Actions (need confirmation)**
- **Remove git history**: delete the `.git` folder to start a fresh repo (recommended if you don't want to keep commit history or references to j4ckgrey).  
- **Replace tracked binary assets**: overwrite icons/screenshots in-place — I will not do this until you provide the new assets and confirm.

**What I need from you before making large changes**
- The new app name (exact string) and the new logo files (PNG/SVG/ICNS as required) so I can safely replace assets and update manifests.  
- Confirm whether to remove `.git` (start fresh) or keep history and instead clean references only.

**How I'll proceed after you confirm**
- If you confirm and provide name + logo, I will run a dry-run replacement and show the diff; after your approval I'll apply the replacements, update `README.md`, and (optionally) remove `.git` and initialize a new repo with a suggested `.gitignore` and GitHub Actions skeleton for building Android/Linux.  

**Notes & License**
- This repo contains code originally from `Fladder` under its existing license. Make sure you comply with any license terms when republishing under a new name.

---
If you'd like, I can now (A) list the files I found with matches and show the exact occurrences, (B) generate a dry-run replacement script, or (C) wait until you provide the new name and logo. Which do you prefer?