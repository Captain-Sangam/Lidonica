import SwiftUI

struct TrackPickerView: View {
    @EnvironmentObject var appState: AppState

    private let columns = [
        GridItem(.adaptive(minimum: 120, maximum: 160), spacing: LidonicaTheme.spacingSM)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: LidonicaTheme.spacingSM) {
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
    }
}
