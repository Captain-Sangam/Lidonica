# Contributing to Lidonica

Thanks for your interest in contributing! Lidonica is a small, playful macOS app and we welcome contributions of all kinds.

## Getting Started

1. Fork the repository and clone it locally.
2. Make sure you have Swift 5.9+ installed (`swift --version`).
3. Build the project:
   ```
   swift build
   swift run Lidonica
   ```
4. If you have Xcode installed, you can also generate the project file:
   ```
   brew install xcodegen
   xcodegen generate
   open Lidonica.xcodeproj
   ```

## What to Contribute

Here are some areas where help is welcome:

- **New tracks** — Add public domain melodies to `Sources/Data/TrackLibrary.swift`
- **New waveforms** — Extend the synth in `Sources/Audio/ToneGenerator.swift`
- **UI polish** — Improve the SwiftUI views, animations, or accessibility
- **Sensor support** — Improve compatibility with more MacBook models
- **Bug fixes** — If something breaks, we want to know
- **Documentation** — README improvements, code comments for tricky sections

## How to Submit Changes

1. Create a branch from `main` with a descriptive name (e.g. `add-happy-birthday-track`).
2. Make your changes. Keep commits focused and well-described.
3. Make sure the project builds cleanly: `swift build`
4. Open a pull request against `main` with a clear description of what you changed and why.

## Code Style

- Follow Swift naming conventions (camelCase for properties, PascalCase for types).
- Use the design tokens in `Sources/Theme/Theme.swift` for any visual constants.
- Keep views small and composable.
- Don't add comments that just narrate what code does — comment the *why*, not the *what*.

## Adding a Track

All tracks must use melodies that are **public domain** or **royalty-free**. When adding a track:

1. Add a `Track` entry in `Sources/Data/TrackLibrary.swift`.
2. Provide MIDI note numbers for the melody and scale arrays.
3. Include `name`, `description`, `genre`, `difficulty`, `tempo`, `waveform`, and `reverbMix`.
4. Test that the track sounds reasonable with both guided and free play modes.

## Reporting Issues

Open a GitHub issue with:
- What you expected to happen
- What actually happened
- Your macOS version and Mac model (especially for sensor issues)
- Steps to reproduce

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold it.
