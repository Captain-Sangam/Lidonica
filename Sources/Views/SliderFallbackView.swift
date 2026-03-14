import SwiftUI

struct SliderFallbackView: View {
    @EnvironmentObject var appState: AppState
    @State private var sliderValue: Double = 105

    var body: some View {
        VStack(spacing: LidonicaTheme.spacingSM) {
            HStack {
                Text("Lid Angle Simulator")
                    .font(LidonicaTheme.captionFont)
                    .foregroundStyle(LidonicaTheme.textTertiary)
                Spacer()
                Text("\(Int(sliderValue))°")
                    .font(LidonicaTheme.monoFont)
                    .foregroundStyle(LidonicaTheme.textSecondary)
            }

            Slider(value: $sliderValue, in: 40...170, step: 1) {
                Text("Angle")
            }
            .tint(LidonicaTheme.accentIndigo)
            .onChange(of: sliderValue) { _, newValue in
                appState.updateSliderAngle(newValue)
            }

            HStack(spacing: LidonicaTheme.spacingXS) {
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 10))
                Text("Drag to simulate lid movement")
                    .font(LidonicaTheme.captionFont)
            }
            .foregroundStyle(LidonicaTheme.textTertiary)
        }
        .padding(LidonicaTheme.spacingSM + 2)
        .background(LidonicaTheme.backgroundSecondary, in: RoundedRectangle(cornerRadius: LidonicaTheme.radiusMD))
    }
}
