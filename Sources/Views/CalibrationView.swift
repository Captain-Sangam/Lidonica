import SwiftUI

struct CalibrationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: LidonicaTheme.spacingLG) {
            VStack(spacing: LidonicaTheme.spacingSM) {
                Image(systemName: "scope")
                    .font(.system(size: 36))
                    .foregroundStyle(LidonicaTheme.accentIndigo)

                Text("Calibrate")
                    .font(LidonicaTheme.headingFont)
                    .foregroundStyle(LidonicaTheme.textPrimary)

                Text("Hold your screen at a comfortable angle and tap the button below. The app will use this as the center of your play range.")
                    .font(LidonicaTheme.bodyFont)
                    .foregroundStyle(LidonicaTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            LidAngleIndicator(
                angle: appState.currentAngle,
                minAngle: 40,
                maxAngle: 170,
                isActive: true
            )
            .frame(width: 180, height: 120)

            Text("Current angle: \(Int(appState.currentAngle))°")
                .font(LidonicaTheme.monoFont)
                .foregroundStyle(LidonicaTheme.textSecondary)

            VStack(spacing: LidonicaTheme.spacingSM) {
                Button {
                    appState.calibrate()
                    dismiss()
                } label: {
                    Text("Set Center Position")
                        .font(LidonicaTheme.labelFont)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LidonicaTheme.spacingSM + 2)
                        .background(LidonicaTheme.accentIndigo, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD))
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.return, modifiers: [])

                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.plain)
                .foregroundStyle(LidonicaTheme.textSecondary)
                .font(LidonicaTheme.labelFont)
                .keyboardShortcut(.escape, modifiers: [])
            }

            if appState.hasCalibrated {
                Text("Last calibrated at \(Int(appState.calibrationCenter))° ± \(Int(appState.calibrationRange))°")
                    .font(LidonicaTheme.captionFont)
                    .foregroundStyle(LidonicaTheme.textTertiary)
            }

            HStack(spacing: LidonicaTheme.spacingXS) {
                Image(systemName: "hand.raised")
                    .font(.system(size: 11))
                Text("Move your lid gently — no need for big motions")
                    .font(LidonicaTheme.captionFont)
            }
            .foregroundStyle(LidonicaTheme.textTertiary)
        }
        .padding(LidonicaTheme.spacingXL)
        .frame(width: 360)
    }
}
