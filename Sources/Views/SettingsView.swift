import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: LidonicaTheme.spacingLG) {
            HStack {
                Text("Settings")
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

            settingsSection("Appearance") {
                Picker("Theme", selection: $appState.themePreference) {
                    ForEach(ThemePreference.allCases, id: \.self) { pref in
                        Text(pref.rawValue).tag(pref)
                    }
                }
                .pickerStyle(.segmented)
            }

            settingsSection("Audio") {
                VStack(alignment: .leading, spacing: LidonicaTheme.spacingXS) {
                    HStack {
                        Text("Volume")
                            .font(LidonicaTheme.labelFont)
                            .foregroundStyle(LidonicaTheme.textSecondary)
                        Spacer()
                        Text("\(Int(appState.masterVolume * 100))%")
                            .font(LidonicaTheme.monoFont)
                            .foregroundStyle(LidonicaTheme.textTertiary)
                    }
                    Slider(value: $appState.masterVolume, in: 0...1)
                        .tint(LidonicaTheme.accentIndigo)
                }
            }

            settingsSection("Play Mode") {
                VStack(alignment: .leading, spacing: LidonicaTheme.spacingSM) {
                    Picker("Mode", selection: $appState.playMode) {
                        ForEach(PlayMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text(appState.playMode.description)
                        .font(LidonicaTheme.captionFont)
                        .foregroundStyle(LidonicaTheme.textTertiary)
                }
            }

            settingsSection("Calibration") {
                VStack(alignment: .leading, spacing: LidonicaTheme.spacingSM) {
                    if appState.hasCalibrated {
                        Text("Center: \(Int(appState.calibrationCenter))° — Range: ±\(Int(appState.calibrationRange))°")
                            .font(LidonicaTheme.captionFont)
                            .foregroundStyle(LidonicaTheme.textSecondary)
                    }

                    Button {
                        appState.hasCalibrated = false
                        appState.calibrationCenter = 105
                        appState.calibrationRange = 35
                        if appState.sessionState != .ready {
                            appState.stop()
                        }
                        appState.sessionState = .ready
                    } label: {
                        Text("Reset Calibration")
                            .font(LidonicaTheme.labelFont)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            HStack {
                Spacer()
                VStack(spacing: 2) {
                    Text("Lidonica v1.0")
                        .font(LidonicaTheme.captionFont)
                        .foregroundStyle(LidonicaTheme.textTertiary)
                    Text("A Mac lid-angle musical toy")
                        .font(LidonicaTheme.captionFont)
                        .foregroundStyle(LidonicaTheme.textTertiary)
                }
                Spacer()
            }
        }
        .padding(LidonicaTheme.spacingLG)
        .frame(width: 340, height: 500)
    }

    private func settingsSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: LidonicaTheme.spacingSM) {
            Text(title)
                .font(LidonicaTheme.labelFont)
                .foregroundStyle(LidonicaTheme.textPrimary)

            content()
        }
    }
}
