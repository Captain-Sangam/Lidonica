import Foundation

final class NoteMapper {
    func mapAngleToNote(normalizedAngle: Double, track: Track, mode: PlayMode) -> Int? {
        let notes = track.scale
        guard !notes.isEmpty else { return nil }

        let index = Int(normalizedAngle * Double(notes.count - 1))
        let clampedIndex = max(0, min(notes.count - 1, index))
        return notes[clampedIndex]
    }
}
