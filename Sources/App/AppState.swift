import SwiftUI
import Combine

enum SessionState: Equatable {
    case ready
    case calibrated
    case playing
    case paused
}

enum ThemePreference: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

final class AppState: ObservableObject {
    @Published var selectedTrack: Track?
    @Published var sessionState: SessionState = .ready
    @Published var currentAngle: Double = 105
    @Published var currentNote: Int? = nil
    @Published var currentNoteName: String = ""
    @Published var isSensorAvailable: Bool = false
    @Published var isUsingFallback: Bool = false
    @Published var themePreference: ThemePreference {
        didSet { UserDefaults.standard.set(themePreference.rawValue, forKey: "themePreference") }
    }
    @Published var masterVolume: Double {
        didSet {
            UserDefaults.standard.set(masterVolume, forKey: "masterVolume")
            audioEngine.setVolume(Float(masterVolume))
        }
    }
    @Published var isGuidedMode: Bool {
        didSet { UserDefaults.standard.set(isGuidedMode, forKey: "isGuidedMode") }
    }
    @Published var calibrationCenter: Double {
        didSet { UserDefaults.standard.set(calibrationCenter, forKey: "calibrationCenter") }
    }
    @Published var calibrationRange: Double {
        didSet { UserDefaults.standard.set(calibrationRange, forKey: "calibrationRange") }
    }
    @Published var hasCalibrated: Bool {
        didSet { UserDefaults.standard.set(hasCalibrated, forKey: "hasCalibrated") }
    }

    private var lidAngleProvider: LidAngleProvider?
    private let audioEngine = AudioEngine()
    private let noteMapper = NoteMapper()
    private var cancellables = Set<AnyCancellable>()

    var calibrationMin: Double { calibrationCenter - calibrationRange }
    var calibrationMax: Double { calibrationCenter + calibrationRange }

    init() {
        let defaults = UserDefaults.standard
        self.themePreference = ThemePreference(rawValue: defaults.string(forKey: "themePreference") ?? "") ?? .system
        self.masterVolume = defaults.object(forKey: "masterVolume") as? Double ?? 0.7
        self.isGuidedMode = defaults.object(forKey: "isGuidedMode") as? Bool ?? true
        self.calibrationCenter = defaults.object(forKey: "calibrationCenter") as? Double ?? 105
        self.calibrationRange = defaults.object(forKey: "calibrationRange") as? Double ?? 35
        self.hasCalibrated = defaults.bool(forKey: "hasCalibrated")

        selectedTrack = TrackLibrary.tracks.first
        setupSensor()
        audioEngine.setVolume(Float(masterVolume))
    }

    private func setupSensor() {
        let hidSensor = HIDLidSensor()
        if hidSensor.isAvailable {
            lidAngleProvider = hidSensor
            isSensorAvailable = true
            isUsingFallback = false
        } else {
            let slider = SliderLidSensor()
            lidAngleProvider = slider
            isSensorAvailable = false
            isUsingFallback = true
        }

        lidAngleProvider?.angle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] angle in
                self?.handleAngleUpdate(angle)
            }
            .store(in: &cancellables)
    }

    private func handleAngleUpdate(_ rawAngle: Double) {
        currentAngle = rawAngle

        guard sessionState == .playing,
              let track = selectedTrack else { return }

        let normalizedAngle = (rawAngle - calibrationMin) / (calibrationMax - calibrationMin)
        let clampedAngle = max(0, min(1, normalizedAngle))

        let mappedNote = noteMapper.mapAngleToNote(
            normalizedAngle: clampedAngle,
            track: track,
            guided: isGuidedMode
        )

        if mappedNote != currentNote {
            currentNote = mappedNote
            if let note = mappedNote {
                currentNoteName = Note.name(for: note)
                audioEngine.playNote(
                    midiNote: note,
                    waveform: track.waveform,
                    reverbMix: track.reverbMix
                )
            }
        }
    }

    func calibrate() {
        calibrationCenter = currentAngle
        hasCalibrated = true
        if sessionState == .ready {
            sessionState = .calibrated
        }
    }

    func togglePlay() {
        switch sessionState {
        case .ready:
            if !hasCalibrated {
                calibrate()
            }
            sessionState = .playing
            lidAngleProvider?.start()
            audioEngine.start()
        case .calibrated:
            sessionState = .playing
            lidAngleProvider?.start()
            audioEngine.start()
        case .playing:
            sessionState = .paused
            audioEngine.stopNote()
            currentNote = nil
            currentNoteName = ""
        case .paused:
            sessionState = .playing
        }
    }

    func stop() {
        sessionState = hasCalibrated ? .calibrated : .ready
        audioEngine.stopNote()
        audioEngine.stop()
        currentNote = nil
        currentNoteName = ""
    }

    func selectTrack(_ track: Track) {
        let wasPlaying = sessionState == .playing
        if wasPlaying {
            audioEngine.stopNote()
        }
        selectedTrack = track
        currentNote = nil
        currentNoteName = ""
    }

    func updateSliderAngle(_ angle: Double) {
        if let slider = lidAngleProvider as? SliderLidSensor {
            slider.setAngle(angle)
        }
    }

    func switchToFallback() {
        lidAngleProvider?.stop()
        let slider = SliderLidSensor()
        lidAngleProvider = slider
        isUsingFallback = true

        slider.angle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] angle in
                self?.handleAngleUpdate(angle)
            }
            .store(in: &cancellables)
    }

    func handleSleep() {
        if sessionState == .playing {
            audioEngine.stopNote()
            sessionState = .paused
        }
    }

    func handleWake() {
        if isSensorAvailable {
            setupSensor()
        }
    }
}
