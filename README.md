# Lidonica

A minimal macOS music toy that lets you pick a built-in track and play it like a harmonica using your MacBook's lid angle.

## How It Works

Open the app, pick a melody, and move your MacBook screen up and down. The app reads the lid angle sensor and maps the position to notes in the selected track — turning your laptop into a playful musical instrument.

## Features

- **10 built-in tracks** spanning folk, blues, classical, ambient, and jazz
- **Real lid angle sensor** support for MacBooks (2019+)
- **Fallback slider mode** for unsupported devices or desktop Macs
- **Guided mode** with forgiving note snapping to the melody
- **Free play mode** mapping the full scale across the lid range
- **Real-time synthesis** — sine, triangle, and soft saw waveforms with reverb
- **Light and dark themes** following system preference or manual override
- **Calibration** to set your comfortable play range
- **Keyboard shortcuts** — Space to play/pause, Escape to dismiss sheets

## Requirements

- macOS 14.0 (Sonoma) or later
- Swift 5.9+
- For lid angle sensor: MacBook Pro (2021+) or MacBook Air (M2+)

## Build

With Swift Package Manager (no Xcode required):

```
swift build
swift run Lidonica
```

With Xcode (if installed):

```
brew install xcodegen
xcodegen generate
open Lidonica.xcodeproj
```

## Tracks

| Track | Genre | Difficulty |
|---|---|---|
| Twinkle Twinkle | Folk | Easy |
| Ode to Joy | Classical | Easy |
| Amazing Grace | Folk | Easy |
| Au Clair de la Lune | Folk | Easy |
| Greensleeves | Folk | Medium |
| Scarborough Fair | Folk | Medium |
| Danny Boy | Folk | Medium |
| Simple Blues Walk | Blues | Medium |
| Ambient Drift | Ambient | Easy |
| Blue Monk | Jazz | Hard |

## Architecture

```
Sources/
  App/           → App entry point and central state management
  Models/        → Track, Note, PlayMode data models
  Audio/         → AVAudioEngine synthesis with ADSR envelope
  Sensor/        → Lid angle protocol, HID sensor, slider fallback
  Views/         → SwiftUI views (shadcn-inspired design system)
  Theme/         → Design tokens (colors, typography, spacing)
  Data/          → Built-in track library (10 public domain melodies)
```

## Lid Angle Sensor

The app uses the undocumented IOKit HID interface to read the MacBook lid angle sensor (VendorID `0x05AC`, UsagePage `0x0020`, Usage `0x008A`). This requires App Sandbox to be disabled and is not App Store compatible. If the sensor is unavailable, the app automatically falls back to an on-screen slider.

## License

All included melodies are public domain.
