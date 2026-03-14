import Foundation

enum PlayMode: String, CaseIterable {
    case guided = "Guided"
    case freePlay = "Free Play"

    var description: String {
        switch self {
        case .guided:
            return "Notes snap to the melody. Forgiving and musical."
        case .freePlay:
            return "Direct angle-to-note mapping across the full scale."
        }
    }
}
