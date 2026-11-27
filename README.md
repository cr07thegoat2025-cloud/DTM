# DTM - Android 3D Racing Game

Arcade-sim racing featuring the **2004 Audi TT-R #8 Team ABT Sportsline** on a Suzuka-inspired circuit.

Built with **Godot 4.3** (GDScript) targeting Android (arm64-v8a, minSdk 24).

## Features
- VehicleBody3D physics with gears, suspension, downforce, handbrake
- Chase / Bonnet / Cockpit cameras
- Lap timer, best lap, checkpoints, reset
- Touch controls (auto-hide on keyboard/gamepad)
- Full keyboard (WASD / arrows, Space handbrake, C camera, R reset, Esc pause)
- Graphics quality setting (Low / Medium / High)
- Time-trial mode

## Controls
| Action       | Keyboard          | Touch      |
|--------------|-------------------|------------|
| Steer        | A/D or ←/→        | ◀ ▶        |
| Throttle     | W or ↑            | GAS        |
| Brake        | S or ↓            | BRK        |
| Handbrake    | Space             | HB         |
| Camera       | C                 | CAM        |
| Reset        | R                 | RST        |
| Pause        | Esc               | -          |

## Build (local)
1. Install Godot 4.3+
2. Open `project.godot`
3. Install Android export templates
4. Project → Export → Android

## CI / Release APK
GitHub Actions builds a signed (or debug) APK on every `v*` tag and on manual dispatch.

**Secrets to add** (optional for signed release):
- `ANDROID_KEYSTORE_BASE64` – base64 of your .jks/.keystore
- `ANDROID_KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`

If secrets are missing, a debug-signed APK is still produced and attached to the Release.

## Assets
- Car: converted from FBX → GLB (textures kept)
- Track: procedural approximation of Suzuka (original USDZ included; conversion requires Blender + OpenUSD)

See `tools/convert_assets.py` and `CREDITS.md`.

## Legal
Audi, ABT, DTM and related marks are trademarks of their respective owners.  
This project is for **non-commercial, educational / personal use only**.  
Do not redistribute the original proprietary models without proper licences.
