import Foundation

enum Genre: String, CaseIterable, Codable {
    case folk = "Folk"
    case blues = "Blues"
    case classical = "Classical"
    case ambient = "Ambient"
    case jazz = "Jazz"

    var icon: String {
        switch self {
        case .folk: return "leaf"
        case .blues: return "guitars"
        case .classical: return "music.quarternote.3"
        case .ambient: return "cloud"
        case .jazz: return "music.mic"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable, Comparable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    static func < (lhs: Difficulty, rhs: Difficulty) -> Bool {
        let order: [Difficulty] = [.easy, .medium, .hard]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}

enum Tempo: String, CaseIterable, Codable {
    case slow = "Slow"
    case moderate = "Moderate"
    case upbeat = "Upbeat"
}

enum Waveform: String, CaseIterable, Codable {
    case sine = "Sine"
    case triangle = "Triangle"
    case softSaw = "Soft Saw"
}

struct Track: Identifiable, Equatable {
    let id: String
    let name: String
    let description: String
    let genre: Genre
    let difficulty: Difficulty
    let tempo: Tempo
    let waveform: Waveform
    let reverbMix: Float
    let notes: [Int]
    let scale: [Int]

    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
}
