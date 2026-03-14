import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: LidonicaTheme.spacingLG) {
            HStack {
                Text("How to Play")
                    .font(LidonicaTheme.headingFont)
                    .foregroundStyle(LidonicaTheme.textPrimary)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(LidonicaTheme.textTertiary)
                        .frame(width: 28, height: 28)
                        .background(LidonicaTheme.backgroundSecondary, in: Circle())
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.escape, modifiers: [])
            }

            VStack(alignment: .leading, spacing: LidonicaTheme.spacingMD) {
                step(number: 1, icon: "music.note.list", text: "Pick a track from the bottom row")
                step(number: 2, icon: "scope", text: "Tap Calibrate and set your comfortable lid position")
                step(number: 3, icon: "play.fill", text: "Press Play (or hit Space)")
                step(number: 4, icon: "arrow.up.arrow.down", text: "Tilt your lid up and down gently to play notes")
            }

            Divider()

            VStack(alignment: .leading, spacing: LidonicaTheme.spacingSM) {
                Text("Modes")
                    .font(LidonicaTheme.labelFont)
                    .foregroundStyle(LidonicaTheme.textPrimary)

                modeRow(name: "Guided", description: "Melody advances forward with any lid movement")
                modeRow(name: "Free Play", description: "Full scale mapped to lid range — more expressive")
            }

            Divider()

            HStack(spacing: LidonicaTheme.spacingXS) {
                Image(systemName: "hand.raised")
                    .font(.system(size: 11))
                Text("Move gently — small tilts are all you need")
                    .font(LidonicaTheme.captionFont)
            }
            .foregroundStyle(LidonicaTheme.textTertiary)
        }
        .padding(LidonicaTheme.spacingLG)
        .frame(width: 400)
    }

    private func step(number: Int, icon: String, text: String) -> some View {
        HStack(spacing: LidonicaTheme.spacingSM + 2) {
            ZStack {
                Circle()
                    .fill(LidonicaTheme.accentIndigo.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(LidonicaTheme.accentIndigo)
            }

            Text(text)
                .font(LidonicaTheme.bodyFont)
                .foregroundStyle(LidonicaTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func modeRow(name: String, description: String) -> some View {
        HStack(alignment: .top, spacing: LidonicaTheme.spacingSM) {
            Text(name)
                .font(LidonicaTheme.labelFont)
                .foregroundStyle(LidonicaTheme.accentIndigo)
                .frame(width: 70, alignment: .leading)
            Text(description)
                .font(LidonicaTheme.captionFont)
                .foregroundStyle(LidonicaTheme.textSecondary)
        }
    }
}
