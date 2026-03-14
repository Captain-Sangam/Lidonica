# Lidonica

A minimal macOS music toy that lets you pick a built-in track and play it like a harmonica using your MacBook's lid angle.

## How It Works

Open the app, pick a melody, and move your MacBook screen up and down. The app reads the lid angle sensor and maps the position to notes in the selected track — turning your laptop into a playful musical instrument.

## Features

- **14 built-in tracks** spanning folk, blues, classical, ambient, and jazz
- **2 play modes** — Guided (melody advances with any movement) and Free Play (full scale)
- **Real lid angle sensor** support for MacBooks (2019+)
- **Fallback slider mode** for unsupported devices or desktop Macs
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

## Usage

1. **Launch** — `swift run Lidonica` or open the built app
2. **Pick a track** — click one from the grid
3. **Calibrate** — click Calibrate, hold your lid at a comfortable angle, then click Set Center Position
4. **Play** — hit the play button (or press Space) and tilt your lid up and down gently
5. **Switch modes** — open Settings (gear icon) to toggle between Guided and Free Play

**Guided mode** advances through the melody with any lid movement — direction doesn't matter, it always plays forward. **Free Play** maps the full scale directly to the lid range.

On Macs without a lid sensor (desktops, older laptops), an on-screen slider appears automatically as a fallback.

## Tracks

| Track               | Genre     | Difficulty |
| ------------------- | --------- | ---------- |
| Twinkle Twinkle     | Folk      | Easy       |
| Ode to Joy          | Classical | Easy       |
| Amazing Grace       | Folk      | Easy       |
| My Heart Will Go On | Classical | Medium     |
| Für Elise           | Classical | Medium     |
| Canon in D          | Classical | Medium     |
| Greensleeves        | Folk      | Medium     |
| Scarborough Fair    | Folk      | Medium     |
| Danny Boy           | Folk      | Medium     |
| La Vie en Rose      | Jazz      | Medium     |
| Simple Blues Walk   | Blues     | Medium     |
| Ambient Drift       | Ambient   | Easy       |
| Blue Monk           | Jazz      | Hard       |
| Au Clair de la Lune | Folk      | Easy       |

## Architecture

```
Sources/
  App/           → App entry point and central state management
  Models/        → Track, Note, PlayMode data models
  Audio/         → AVAudioEngine synthesis with ADSR envelope
  Sensor/        → Lid angle protocol, HID sensor, slider fallback
  Views/         → SwiftUI views (shadcn-inspired design system)
  Theme/         → Design tokens (colors, typography, spacing)
  Data/          → Built-in track library (14 public domain melodies)
```

## Lid Angle Sensor

The app uses the undocumented IOKit HID interface to read the MacBook lid angle sensor (VendorID `0x05AC`, UsagePage `0x0020`, Usage `0x008A`). This requires App Sandbox to be disabled and is not App Store compatible. If the sensor is unavailable, the app automatically falls back to an on-screen slider.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License. See [LICENSE](LICENSE) for details.

All included melodies are public domain.
