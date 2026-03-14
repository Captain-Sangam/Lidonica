# AGENTS.md — Lidonica

Guidelines for AI coding agents working on this codebase.

## Project Overview

Lidonica is a native macOS SwiftUI app that turns a MacBook into a musical instrument using lid angle input. Users pick a built-in melody track and "play" it by tilting the screen — the lid angle maps to notes in the selected track.

## Tech Stack

- **Language**: Swift 5.9+
- **UI**: SwiftUI (macOS 14.0+ / Sonoma)
- **Audio**: AVAudioEngine with AVAudioSourceNode for real-time waveform synthesis
- **Sensor**: IOKit HID for lid angle reading (private API, not App Store safe)
- **Build**: Swift Package Manager (`swift build`) or XcodeGen (`project.yml` → `.xcodeproj`)
- **Persistence**: UserDefaults for settings and calibration

## Repository Layout

```
Sources/
  App/             LidonicaApp.swift (entry point), AppState.swift (central state)
  Models/          Track, Note, PlayMode data models
  Audio/           AudioEngine (AVAudioEngine wrapper), ToneGenerator (waveform synthesis), NoteMapper
  Sensor/          LidAngleProvider protocol, HIDLidSensor (real), SliderLidSensor (fallback)
  Views/           All SwiftUI views — ContentView, PlayerView, TrackPickerView, etc.
  Theme/           Design tokens (colors, spacing, typography, radius)
  Data/            TrackLibrary (10 built-in public domain tracks)
Resources/
  Info.plist       App metadata
  Assets.xcassets/ App icon, accent color
```

## Architecture

- **AppState** (`ObservableObject`) is the single source of truth. It owns the sensor, audio engine, and note mapper. Views observe it via `@EnvironmentObject`.
- **LidAngleProvider** is a protocol. `HIDLidSensor` implements it for real hardware; `SliderLidSensor` implements it for fallback. The app auto-detects which to use at launch.
- **AudioEngine** wraps `AVAudioEngine` and routes a `ToneGenerator` (AVAudioSourceNode) through reverb to the main mixer. The tone generator produces sine, triangle, or soft saw waveforms with ADSR envelope.
- **NoteMapper** translates a normalized angle (0–1) into a MIDI note based on the selected track's melody (guided mode) or scale (free play mode).

## Data Flow

```
LidAngleProvider → AppState.handleAngleUpdate → NoteMapper.mapAngleToNote → AudioEngine.playNote
```

Sensor publishes angle via `CurrentValueSubject<Double, Never>`. AppState subscribes, normalizes against calibration range, maps to a MIDI note, and triggers the audio engine when the note changes.

## Build & Run

```bash
swift build
swift run Lidonica
```

Or with Xcode:

```bash
brew install xcodegen
xcodegen generate
open Lidonica.xcodeproj
```

## Conventions

### Code Style

- No comments that merely narrate what code does. Comments explain *why*, not *what*.
- Use Swift naming conventions: camelCase for properties/methods, PascalCase for types.
- Prefer value types (struct, enum) for models. Use classes only when reference semantics are needed (ObservableObject, audio/sensor managers).
- Keep views small. Extract subviews into computed properties or separate structs when a view body exceeds ~40 lines.

### Design System

All visual constants live in `Sources/Theme/Theme.swift` under the `LidonicaTheme` enum. Use these tokens instead of hardcoded values:

- Colors: `LidonicaTheme.textPrimary`, `.cardBackground`, `.accentIndigo`, etc.
- Fonts: `LidonicaTheme.titleFont`, `.bodyFont`, `.captionFont`, etc.
- Spacing: `LidonicaTheme.spacingSM` (8pt), `.spacingMD` (16pt), `.spacingLG` (24pt)
- Radius: `LidonicaTheme.radiusMD` (8pt), `.radiusLG` (12pt)

All colors support light and dark mode via the `Color(light:dark:)` initializer.

### State Management

- All persistent settings use `UserDefaults` via `@Published` properties on `AppState` with `didSet` handlers.
- Session state follows the enum: `.ready → .calibrated → .playing ⇄ .paused`.
- Sensor availability is checked once at init. If unavailable, `isUsingFallback` is set and the slider provider is used.

### Audio

- Tracks define both a `notes` array (melody for guided mode) and a `scale` array (for free play).
- Each track specifies its own `waveform` and `reverbMix`.
- The ToneGenerator uses ADSR envelope (attack 20ms, decay 50ms, sustain 0.7, release 150ms) and portamento (50ms glide) for smooth transitions.

### Sensor

- The HID lid sensor requires App Sandbox to be disabled.
- Matching criteria fall back progressively: exact (VID+PID+UsagePage+Usage) → relaxed (VID+UsagePage+Usage) → minimal (UsagePage+Usage).
- Angle smoothing uses an exponential moving average with factor 0.3.

## Testing Notes

- The HID sensor only works on MacBooks with a lid angle sensor (2019+ models, some M1 excluded). On desktop Macs or unsupported laptops, the app falls back to the slider.
- To test the full flow without a supported MacBook, use the slider fallback — the app detects sensor unavailability automatically.
- Audio output requires speakers or headphones. The synth generates real-time waveforms, not pre-recorded samples.

## Common Tasks

### Adding a New Track

1. Add a new `Track` entry in `Sources/Data/TrackLibrary.swift`.
2. Provide MIDI note numbers for the melody (`notes`) and the playable scale (`scale`).
3. Choose a `waveform` (.sine, .triangle, .softSaw) and `reverbMix` (0.0–1.0).
4. All melodies must be public domain or royalty-free.

### Adding a New Waveform

1. Add a case to the `Waveform` enum in `Sources/Models/Track.swift`.
2. Implement the generation logic in `ToneGenerator.generateSample()` in `Sources/Audio/ToneGenerator.swift`.

### Modifying the Design System

Edit `Sources/Theme/Theme.swift`. All views reference `LidonicaTheme` constants, so changes propagate globally.
