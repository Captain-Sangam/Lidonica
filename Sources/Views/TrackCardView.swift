import SwiftUI

struct TrackCardView: View {
    let track: Track
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: LidonicaTheme.spacingXS) {
                HStack {
                    Image(systemName: track.genre.icon)
                        .font(.system(size: 12))
                        .foregroundStyle(isSelected ? LidonicaTheme.accentIndigo : LidonicaTheme.textTertiary)

                    Spacer()

                    difficultyDots
                }

                Text(track.name)
                    .font(LidonicaTheme.labelFont)
                    .foregroundStyle(isSelected ? LidonicaTheme.textPrimary : LidonicaTheme.textSecondary)
                    .lineLimit(1)

                Text(track.genre.rawValue)
                    .font(LidonicaTheme.captionFont)
                    .foregroundStyle(LidonicaTheme.textTertiary)
            }
            .padding(LidonicaTheme.spacingSM + 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isSelected ? LidonicaTheme.cardBackgroundSelected : LidonicaTheme.cardBackground,
                in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusLG)
            )
            .overlay(
                RoundedRectangle(cornerRadius: LidonicaTheme.radiusLG)
                    .stroke(
                        isSelected ? LidonicaTheme.borderSelected : LidonicaTheme.border,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .subtleShadow()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(track.name), \(track.genre.rawValue), \(track.difficulty.rawValue)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var difficultyDots: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(dotColor(index: i))
                    .frame(width: 5, height: 5)
            }
        }
    }

    private func dotColor(index: Int) -> Color {
        let filled: Int
        switch track.difficulty {
        case .easy: filled = 1
        case .medium: filled = 2
        case .hard: filled = 3
        }
        return index < filled
            ? (isSelected ? LidonicaTheme.accentIndigo : LidonicaTheme.textTertiary)
            : LidonicaTheme.gaugeTrack
    }
}
