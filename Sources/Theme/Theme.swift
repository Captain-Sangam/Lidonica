import SwiftUI

enum LidonicaTheme {
    // MARK: - Colors

    static let accent = Color("AccentColor")
    static let accentIndigo = Color(light: .init(red: 0.388, green: 0.518, blue: 0.957),
                                     dark: .init(red: 0.502, green: 0.604, blue: 0.976))

    static let backgroundPrimary = Color(light: .white, dark: .init(red: 0.06, green: 0.06, blue: 0.07))
    static let backgroundSecondary = Color(light: .init(red: 0.97, green: 0.97, blue: 0.98),
                                            dark: .init(red: 0.10, green: 0.10, blue: 0.11))
    static let cardBackground = Color(light: .init(red: 0.97, green: 0.97, blue: 0.98),
                                       dark: .init(red: 0.13, green: 0.13, blue: 0.14))
    static let cardBackgroundSelected = Color(light: .init(red: 0.93, green: 0.94, blue: 0.99),
                                               dark: .init(red: 0.15, green: 0.16, blue: 0.22))

    static let border = Color(light: .init(red: 0.88, green: 0.88, blue: 0.90),
                               dark: .init(red: 0.22, green: 0.22, blue: 0.24))
    static let borderSelected = Color(light: .init(red: 0.388, green: 0.518, blue: 0.957).opacity(0.5),
                                       dark: .init(red: 0.502, green: 0.604, blue: 0.976).opacity(0.5))

    static let textPrimary = Color(light: .init(red: 0.07, green: 0.07, blue: 0.08),
                                    dark: .init(red: 0.95, green: 0.95, blue: 0.96))
    static let textSecondary = Color(light: .init(red: 0.40, green: 0.40, blue: 0.42),
                                      dark: .init(red: 0.60, green: 0.60, blue: 0.62))
    static let textTertiary = Color(light: .init(red: 0.60, green: 0.60, blue: 0.62),
                                     dark: .init(red: 0.42, green: 0.42, blue: 0.44))

    static let noteGlow = Color(light: .init(red: 0.388, green: 0.518, blue: 0.957).opacity(0.3),
                                 dark: .init(red: 0.502, green: 0.604, blue: 0.976).opacity(0.3))

    static let gaugeTrack = Color(light: .init(red: 0.90, green: 0.90, blue: 0.92),
                                   dark: .init(red: 0.18, green: 0.18, blue: 0.20))
    static let gaugeActive = accentIndigo

    // MARK: - Spacing

    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32

    // MARK: - Radius

    static let radiusSM: CGFloat = 6
    static let radiusMD: CGFloat = 8
    static let radiusLG: CGFloat = 12
    static let radiusXL: CGFloat = 20

    // MARK: - Typography

    static let titleFont: Font = .system(size: 28, weight: .semibold, design: .rounded)
    static let headingFont: Font = .system(size: 20, weight: .medium, design: .rounded)
    static let bodyFont: Font = .system(size: 15, weight: .regular, design: .rounded)
    static let captionFont: Font = .system(size: 12, weight: .regular, design: .rounded)
    static let monoFont: Font = .system(size: 14, weight: .medium, design: .monospaced)
    static let noteFont: Font = .system(size: 42, weight: .bold, design: .rounded)
    static let labelFont: Font = .system(size: 13, weight: .medium, design: .rounded)
}

// MARK: - Color Extension for Light/Dark

extension Color {
    init(light: Color, dark: Color) {
        self.init(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return isDark ? NSColor(dark) : NSColor(light)
        }))
    }
}

// MARK: - Shadow Modifier

struct SubtleShadow: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        if colorScheme == .light {
            content.shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
        } else {
            content
        }
    }
}

extension View {
    func subtleShadow() -> some View {
        modifier(SubtleShadow())
    }
}
