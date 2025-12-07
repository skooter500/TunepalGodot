# iOS Development Guide

This guide covers building and testing Tunepal on iOS, including the iOS Simulator.

## Prerequisites

### Required Software

1. **macOS** (required for iOS development)
2. **Xcode** (from App Store)
   - After installing, run: `xcode-select --install` for command line tools
   - Open Xcode once to accept the license agreement
3. **Godot 4.3+** ([download](https://godotengine.org/download/macos/))
4. **SCons** for building the C++ extension:
   ```bash
   pip3 install scons
   ```

### Verify Xcode Setup

```bash
# Check Xcode is installed
xcode-select -p
# Should output: /Applications/Xcode.app/Contents/Developer

# Check available simulators
xcrun simctl list devices available
```

## Building the C++ Extension for iOS

The Tunepal edit distance algorithm is a C++ GDExtension that must be compiled for iOS.

### 1. Initialize Submodules

```bash
cd tunepalgodot-d
git submodule update --init --recursive
```

### 2. Build for iOS Simulator (arm64)

For M1/M2/M3 Macs (Apple Silicon):
```bash
scons platform=ios target=template_debug arch=arm64 ios_simulator=yes -j4
```

For Intel Macs:
```bash
scons platform=ios target=template_debug arch=x86_64 ios_simulator=yes -j4
```

### 3. Build for iOS Device (arm64)

```bash
scons platform=ios target=template_debug arch=arm64 -j4
scons platform=ios target=template_release arch=arm64 -j4
```

The built libraries will be placed in:
```
TunepalGodot/addons/tunepal/bin/libtunepal.ios.template_debug.arm64.dylib
TunepalGodot/addons/tunepal/bin/libtunepal.ios.template_release.arm64.dylib
```

## Running in iOS Simulator

### Method 1: Using Godot Editor (Recommended for Development)

1. **Open the project** in Godot 4.3+:
   ```bash
   godot --editor --path TunepalGodot
   ```

2. **Configure iOS export** (already done):
   - Project → Export → iOS preset exists
   - Microphone permission is configured

3. **Export for iOS**:
   - Project → Export → iOS
   - Click "Export Project"
   - Save as `tunepal.xcodeproj`

4. **Open in Xcode**:
   ```bash
   open tunepal.xcodeproj
   ```

5. **Select Simulator**:
   - In Xcode, select a simulator from the device dropdown (e.g., "iPhone 15")
   - Click the Run button (▶️) or press `Cmd+R`

### Method 2: Command Line Export

```bash
cd TunepalGodot

# Export debug build for iOS
godot --headless --export-debug "iOS" ../build/tunepal-ios-debug.xcodeproj

# Build and run in simulator using xcodebuild
cd ../build
xcodebuild -project tunepal-ios-debug.xcodeproj \
  -scheme tunepal \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -configuration Debug \
  build

# Or open in Xcode
open tunepal-ios-debug.xcodeproj
```

### Method 3: One-Click Run (After Initial Setup)

Once you have the Xcode project:
```bash
# List available simulators
xcrun simctl list devices available | grep iPhone

# Boot a simulator
xcrun simctl boot "iPhone 15"

# Install and run (after building .app)
xcrun simctl install booted path/to/Tunepal.app
xcrun simctl launch booted org.tunepal.app
```

## Testing Microphone in Simulator

**Important**: The iOS Simulator has limited microphone support.

- **macOS 14+**: Simulator can use Mac's microphone (grant permission when prompted)
- **Older macOS**: Microphone may not work; use a real device for audio testing

To test microphone access:
1. Run the app in Simulator
2. Tap "Record"
3. Grant microphone permission when prompted
4. The app should detect audio from your Mac's microphone

## Running on a Physical Device

### Without Apple Developer Account (Free)

1. Open the exported `.xcodeproj` in Xcode
2. Select your physical iPhone from the device dropdown
3. Go to Signing & Capabilities
4. Select your personal team (Apple ID)
5. Change Bundle Identifier if needed (must be unique)
6. Build and run

**Limitations**: App expires after 7 days, must reinstall.

### With Apple Developer Account ($99/year)

1. Create App ID in Apple Developer portal
2. Create provisioning profile
3. Update `export_presets.cfg`:
   ```ini
   application/app_store_team_id="YOUR_TEAM_ID"
   application/provisioning_profile_uuid_debug="YOUR_PROFILE_UUID"
   ```
4. Build and deploy to TestFlight for wider testing

## Troubleshooting

### "No provisioning profile" Error

For local testing, use your Apple ID:
- Xcode → Preferences → Accounts → Add Apple ID
- Select "Personal Team" in Signing

### Extension Not Loading

Check the GDExtension paths in `tunepal.gdextension`:
```ini
ios.debug.arm64 = "res://addons/tunepal/bin/libtunepal.ios.template_debug.arm64.dylib"
```

Ensure the `.dylib` file exists after building.

### Simulator Won't Start

```bash
# Reset simulator
xcrun simctl erase all

# Or delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Microphone Permission Denied

The app requests microphone with this message (configured in `export_presets.cfg`):
> "Tunepal needs microphone access to recognize tunes you play or sing"

If denied, go to Settings → Privacy → Microphone → Enable for Tunepal.

## CI/CD for iOS

The GitHub Actions workflow (`.github/workflows/build.yml`) builds the iOS extension automatically:
- Builds on `macos-latest` runner
- Produces `libtunepal.ios.template_debug.arm64.dylib`
- Artifacts available for download

To use CI-built binaries:
1. Go to Actions tab on GitHub
2. Download `tunepal-ios-arm64` artifact
3. Place in `TunepalGodot/addons/tunepal/bin/`

## Quick Reference

```bash
# Build extension for simulator (Apple Silicon Mac)
scons platform=ios target=template_debug arch=arm64 ios_simulator=yes -j4

# Build extension for device
scons platform=ios target=template_debug arch=arm64 -j4

# Open project in Godot
godot --editor --path TunepalGodot

# List simulators
xcrun simctl list devices available

# Boot simulator
xcrun simctl boot "iPhone 15"
```
