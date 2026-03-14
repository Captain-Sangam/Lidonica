import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    @State private var showSettings = false
    @State private var showCalibration = false

    var body: some View {
        ZStack {
            LidonicaTheme.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, LidonicaTheme.spacingLG)
                    .padding(.top, LidonicaTheme.spacingMD)

                Spacer(minLength: LidonicaTheme.spacingMD)

                centerPanel
                    .padding(.horizontal, LidonicaTheme.spacingLG)

                Spacer(minLength: LidonicaTheme.spacingMD)

                bottomSection
                    .padding(.bottom, LidonicaTheme.spacingMD)
            }
        }
        .preferredColorScheme(colorSchemeOverride)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showCalibration) {
            CalibrationView()
                .environmentObject(appState)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWorkspace.willSleepNotification)) { _ in
            appState.handleSleep()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWorkspace.didWakeNotification)) { _ in
            appState.handleWake()
        }
    }

    private var colorSchemeOverride: ColorScheme? {
        switch appState.themePreference {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Text("Lidonica")
                .font(LidonicaTheme.titleFont)
                .foregroundStyle(LidonicaTheme.textPrimary)

            Spacer()

            HStack(spacing: LidonicaTheme.spacingSM) {
                themeToggle
                settingsButton
            }
        }
    }

    private var themeToggle: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                switch appState.themePreference {
                case .system: appState.themePreference = .dark
                case .dark: appState.themePreference = .light
                case .light: appState.themePreference = .system
                }
            }
        } label: {
            Image(systemName: themeIcon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(LidonicaTheme.textSecondary)
                .frame(width: 32, height: 32)
                .background(LidonicaTheme.cardBackground, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD))
        }
        .buttonStyle(.plain)
        .help("Theme: \(appState.themePreference.rawValue)")
    }

    private var themeIcon: String {
        switch appState.themePreference {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max"
        case .dark: return "moon"
        }
    }

    private var settingsButton: some View {
        Button {
            showSettings = true
        } label: {
            Image(systemName: "gearshape")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(LidonicaTheme.textSecondary)
                .frame(width: 32, height: 32)
                .background(LidonicaTheme.cardBackground, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD))
        }
        .buttonStyle(.plain)
        .help("Settings")
    }

    // MARK: - Center Panel

    private var centerPanel: some View {
        VStack(spacing: LidonicaTheme.spacingLG) {
            if appState.isUsingFallback {
                fallbackBanner
            }

            PlayerView(showCalibration: $showCalibration)
                .environmentObject(appState)
        }
    }

    private var fallbackBanner: some View {
        HStack(spacing: LidonicaTheme.spacingSM) {
            Image(systemName: "info.circle")
                .foregroundStyle(LidonicaTheme.accentIndigo)
            Text("Lid sensor not detected — using on-screen slider")
                .font(LidonicaTheme.captionFont)
                .foregroundStyle(LidonicaTheme.textSecondary)
        }
        .padding(.horizontal, LidonicaTheme.spacingMD)
        .padding(.vertical, LidonicaTheme.spacingSM)
        .background(LidonicaTheme.cardBackground, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD))
        .overlay(
            RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD)
                .stroke(LidonicaTheme.border, lineWidth: 1)
        )
    }

    // MARK: - Bottom Section

    private var bottomSection: some View {
        VStack(spacing: LidonicaTheme.spacingMD) {
            TrackPickerView()
                .environmentObject(appState)

            HStack(spacing: LidonicaTheme.spacingMD) {
                Button {
                    showCalibration = true
                } label: {
                    Label("Calibrate", systemImage: "scope")
                        .font(LidonicaTheme.labelFont)
                        .foregroundStyle(LidonicaTheme.textSecondary)
                        .padding(.horizontal, LidonicaTheme.spacingMD)
                        .padding(.vertical, LidonicaTheme.spacingSM)
                        .background(LidonicaTheme.cardBackground, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD))
                        .overlay(
                            RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD)
                                .stroke(LidonicaTheme.border, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)

                statusText
            }
            .padding(.horizontal, LidonicaTheme.spacingLG)
        }
    }

    private var statusText: some View {
        Text(statusMessage)
            .font(LidonicaTheme.captionFont)
            .foregroundStyle(LidonicaTheme.textTertiary)
    }

    private var statusMessage: String {
        switch appState.sessionState {
        case .ready:
            return appState.hasCalibrated ? "Ready — select a track and play" : "Calibrate to get started"
        case .calibrated:
            return "Calibrated — tap play to begin"
        case .playing:
            return "Playing — move the lid gently"
        case .paused:
            return "Paused"
        }
    }
}
