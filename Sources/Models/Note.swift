import Foundation

enum Note {
    static let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    static func frequency(for midiNote: Int) -> Double {
        440.0 * pow(2.0, Double(midiNote - 69) / 12.0)
    }

    static func name(for midiNote: Int) -> String {
        let noteName = noteNames[midiNote % 12]
        let octave = (midiNote / 12) - 1
        return "\(noteName)\(octave)"
    }

    static func midiNote(name: String, octave: Int) -> Int {
        guard let index = noteNames.firstIndex(of: name) else { return 60 }
        return (octave + 1) * 12 + index
    }

    // Standard MIDI note constants
    static let C4 = 60
    static let D4 = 62
    static let E4 = 64
    static let F4 = 65
    static let G4 = 67
    static let A4 = 69
    static let B4 = 71
    static let C5 = 72
    static let D5 = 74
    static let E5 = 76
}
