import Foundation

final class NoteMapper {
    /// Maps a normalized angle (0...1) to a MIDI note from the track.
    /// In guided mode, maps to melody notes. In free play, maps to scale notes.
    func mapAngleToNote(normalizedAngle: Double, track: Track, guided: Bool) -> Int? {
        let notes = guided ? track.notes : track.scale
        guard !notes.isEmpty else { return nil }

        let uniqueNotes = guided ? notes : notes
        let index = Int(normalizedAngle * Double(uniqueNotes.count - 1))
        let clampedIndex = max(0, min(uniqueNotes.count - 1, index))

        return uniqueNotes[clampedIndex]
    }
}
