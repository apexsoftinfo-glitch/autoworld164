---
name: iOS Icon Composer Integration
description: This skill should be used when the user asks to "add Icon Composer icon", "add .icon file to iOS", "integrate Liquid Glass icon", "add iOS 26 app icon", mentions "AppIcon.icon", ".icon file", or has a ".icon" file to add to their Flutter/iOS project. Provides step-by-step guidance for integrating Apple Icon Composer files into Xcode projects.
version: 1.0.0
---

# Icon Composer Integration for iOS/Flutter Projects

Integrate Apple Icon Composer `.icon` files into iOS and Flutter projects for Liquid Glass app icons on iOS 26+.

## Overview

Icon Composer is Apple's tool (Xcode 26+) for creating layered Liquid Glass app icons. The `.icon` format replaces multiple PNG exports with a single bundle containing layers, effects, and metadata.

**Key facts:**
- `.icon` files are for **iOS 26+** (Liquid Glass design)
- Keep existing `AppIcon.appiconset` for **iOS 18 and earlier**
- The `.icon` file goes in `ios/Runner/` (NOT inside Assets.xcassets)
- Requires modifications to `project.pbxproj`

## Prerequisites

- macOS Sequoia 15.3+
- Xcode 26+
- A valid `.icon` file from Icon Composer

## .icon File Structure

The `.icon` file is a bundle (directory) containing:

```
name.icon/
├── icon.json       # Layer definitions, effects, positions
└── Assets/         # Source PNG images for layers
```

**icon.json** defines:
- Layer order and positions
- Glass effects and opacity
- Shadows and translucency
- Supported platforms (iOS, watchOS)

## Integration Process

### Step 1: Validate the .icon File

Before integration, validate the `.icon` file structure:

```bash
.claude/skills/ios-icon-composer/scripts/validate-icon.sh path/to/icon.icon
```

Or manually verify:
- Directory ends with `.icon`
- Contains `icon.json` file
- Contains `Assets/` folder with PNG files

### Step 2: Copy to ios/Runner/

Copy the `.icon` bundle to the iOS Runner folder (same level as Assets.xcassets):

```bash
cp -R path/to/source.icon ios/Runner/AppIcon.icon
```

**Important:** Place at `ios/Runner/`, NOT inside `Assets.xcassets/`.

### Step 3: Add to Xcode Project (Two Options)

#### Option A: Via Xcode GUI (Recommended)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Drag the `.icon` file from `ios/Runner/` to Project Navigator
3. In dialog: check "Copy items if needed" and "Add to target: Runner"
4. Go to Target → General → App Icons and Launch Screen
5. Set "App Icon" field to icon name (without .icon extension)
6. Clean Build Folder (Cmd+Shift+K) and rebuild

#### Option B: Manual project.pbxproj Edit

Modify `ios/Runner.xcodeproj/project.pbxproj` with these changes:

**1. Generate unique 24-char hex ID** (e.g., `0FD719E02F1296C700DD8B3B`)

**2. Add to PBXFileReference section:**
```
{ID} /* iconname.icon */ = {isa = PBXFileReference; lastKnownFileType = folder.iconcomposer.icon; path = iconname.icon; sourceTree = "<group>"; };
```

**3. Add to PBXBuildFile section:**
```
{ID2} /* iconname.icon in Resources */ = {isa = PBXBuildFile; fileRef = {ID} /* iconname.icon */; };
```

**4. Add to Runner PBXGroup children:**
```
{ID} /* iconname.icon */,
```

**5. Add to PBXResourcesBuildPhase files:**
```
{ID2} /* iconname.icon in Resources */,
```

**6. Update ASSETCATALOG_COMPILER_APPICON_NAME** in all XCBuildConfiguration sections:
```
ASSETCATALOG_COMPILER_APPICON_NAME = iconname;
```

### Step 4: Keep Backward Compatibility

**Do NOT delete** `AppIcon.appiconset` from Assets.xcassets. It provides icons for iOS 18 and earlier:

```
ios/Runner/
├── Assets.xcassets/
│   └── AppIcon.appiconset/     # iOS 18 and earlier
├── iconname.icon/               # iOS 26+ (Liquid Glass)
└── ...
```

### Step 5: Build and Test

```bash
flutter clean
flutter build ios --no-codesign
```

Test on:
- **iOS 26+ device/simulator**: Shows Liquid Glass icon from `.icon`
- **iOS 18 device/simulator**: Shows traditional icon from `.appiconset`

## Critical Technical Details

### File Type Identifier

The key Xcode identifier for `.icon` files:
```
lastKnownFileType = folder.iconcomposer.icon
```

### project.pbxproj Sections Modified

| Section | Purpose |
|---------|---------|
| PBXFileReference | Register file with Xcode |
| PBXBuildFile | Link to build process |
| PBXGroup (Runner) | Show in Project Navigator |
| PBXResourcesBuildPhase | Include in app bundle |
| XCBuildConfiguration | Set as app icon |

### Naming Convention

- Icon name in settings = filename without `.icon` extension
- `challange_this.icon` → `ASSETCATALOG_COMPILER_APPICON_NAME = challange_this`

## Troubleshooting

### Icon Not Showing on iOS 26

1. Verify `.icon` is in `ios/Runner/` (not Assets.xcassets)
2. Check `ASSETCATALOG_COMPILER_APPICON_NAME` matches filename
3. Clean build folder and rebuild
4. Delete app from device and reinstall

### Build Error: "No matching app icon set"

The `.appiconset` is missing. Keep both:
- `AppIcon.appiconset` in Assets.xcassets (for older iOS)
- `iconname.icon` in Runner folder (for iOS 26+)

### Old Icon Still Showing

1. Clean build folder (Cmd+Shift+K)
2. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Delete app from simulator/device
4. Rebuild

### Cross-Platform Limitations

On **Windows/Linux**:
- Can copy `.icon` files (they're just directories)
- Can edit `project.pbxproj` manually
- Cannot verify build (requires macOS + Xcode)

## Utility Scripts

### Validation Script

Use `.claude/skills/ios-icon-composer/scripts/validate-icon.sh` to validate `.icon` structure before integration.

## Quick Reference

| Task | Location/Value |
|------|----------------|
| Place .icon file | `ios/Runner/` |
| File type | `folder.iconcomposer.icon` |
| Build setting | `ASSETCATALOG_COMPILER_APPICON_NAME` |
| Backward compat | Keep `AppIcon.appiconset` |
| iOS 26+ icons | From `.icon` file |
| iOS 18- icons | From `.appiconset` |
