import SwiftUI

struct TrackPickerView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: LidonicaTheme.spacingSM) {
                ForEach(TrackLibrary.tracks) { track in
                    TrackCardView(
                        track: track,
                        isSelected: appState.selectedTrack?.id == track.id
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            appState.selectTrack(track)
                        }
                    }
                }
            }
            .padding(.horizontal, LidonicaTheme.spacingLG)
            .padding(.vertical, LidonicaTheme.spacingXS)
        }
    }
}
