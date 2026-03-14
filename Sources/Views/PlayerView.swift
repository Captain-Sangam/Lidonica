import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showCalibration: Bool

    var body: some View {
        VStack(spacing: LidonicaTheme.spacingLG) {
            selectedTrackCard

            HStack(spacing: LidonicaTheme.spacingXL) {
                LidAngleIndicator(
                    angle: appState.currentAngle,
                    minAngle: appState.calibrationMin,
                    maxAngle: appState.calibrationMax,
                    isActive: appState.sessionState == .playing
                )
                .frame(width: 140, height: 100)

                VStack(spacing: LidonicaTheme.spacingMD) {
                    noteDisplay
                    playControls
                }
            }

            if appState.isUsingFallback {
                SliderFallbackView()
                    .environmentObject(appState)
            }
        }
        .padding(LidonicaTheme.spacingLG)
        .background(LidonicaTheme.cardBackground, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusLG))
        .overlay(
            RoundedRectangle(cornerRadius: LidonicaTheme.radiusLG)
                .stroke(LidonicaTheme.border, lineWidth: 1)
        )
        .subtleShadow()
    }

    // MARK: - Selected Track

    private var selectedTrackCard: some View {
        Group {
            if let track = appState.selectedTrack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(track.name)
                            .font(LidonicaTheme.headingFont)
                            .foregroundStyle(LidonicaTheme.textPrimary)
                        Text(track.description)
                            .font(LidonicaTheme.captionFont)
                            .foregroundStyle(LidonicaTheme.textSecondary)
                    }
                    Spacer()
                    HStack(spacing: LidonicaTheme.spacingXS) {
                        genreBadge(track.genre)
                        difficultyBadge(track.difficulty)
                    }
                }
            } else {
                Text("Select a track below to get started")
                    .font(LidonicaTheme.bodyFont)
                    .foregroundStyle(LidonicaTheme.textTertiary)
            }
        }
    }

    private func genreBadge(_ genre: Genre) -> some View {
        Text(genre.rawValue)
            .font(LidonicaTheme.captionFont)
            .foregroundStyle(LidonicaTheme.accentIndigo)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(LidonicaTheme.accentIndigo.opacity(0.12), in: Capsule())
    }

    private func difficultyBadge(_ difficulty: Difficulty) -> some View {
        Text(difficulty.rawValue)
            .font(LidonicaTheme.captionFont)
            .foregroundStyle(LidonicaTheme.textSecondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(LidonicaTheme.backgroundSecondary, in: Capsule())
    }

    // MARK: - Note Display

    private var noteDisplay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: LidonicaTheme.radiusXL)
                .fill(LidonicaTheme.backgroundSecondary)
                .frame(width: 140, height: 80)

            if appState.sessionState == .playing, !appState.currentNoteName.isEmpty {
                Text(appState.currentNoteName)
                    .font(LidonicaTheme.noteFont)
                    .foregroundStyle(LidonicaTheme.accentIndigo)
                    .shadow(color: LidonicaTheme.noteGlow, radius: 12)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeOut(duration: 0.15), value: appState.currentNoteName)
            } else {
                VStack(spacing: 2) {
                    Image(systemName: "music.note")
                        .font(.system(size: 24))
                        .foregroundStyle(LidonicaTheme.textTertiary)
                    Text("Note")
                        .font(LidonicaTheme.captionFont)
                        .foregroundStyle(LidonicaTheme.textTertiary)
                }
            }
        }
    }

    // MARK: - Play Controls

    private var playControls: some View {
        HStack(spacing: LidonicaTheme.spacingMD) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    appState.togglePlay()
                }
            } label: {
                Image(systemName: playIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(LidonicaTheme.accentIndigo, in: Circle())
                    .shadow(color: LidonicaTheme.accentIndigo.opacity(0.3), radius: 8)
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.space, modifiers: [])

            if appState.sessionState == .playing || appState.sessionState == .paused {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        appState.stop()
                    }
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(LidonicaTheme.textSecondary)
                        .frame(width: 40, height: 40)
                        .background(LidonicaTheme.backgroundSecondary, in: Circle())
                        .overlay(Circle().stroke(LidonicaTheme.border, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private var playIcon: String {
        switch appState.sessionState {
        case .ready, .calibrated: return "play.fill"
        case .playing: return "pause.fill"
        case .paused: return "play.fill"
        }
    }
}
