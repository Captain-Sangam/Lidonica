import Foundation

enum PlayMode: String, CaseIterable {
    case guided = "Guided"
    case freePlay = "Free Play"

    var description: String {
        switch self {
        case .guided:
            return "Melody advances forward with any lid movement."
        case .freePlay:
            return "Direct angle-to-note mapping across the full scale."
        }
    }
}
