import SwiftUI

struct LidAngleIndicator: View {
    let angle: Double
    let minAngle: Double
    let maxAngle: Double
    let isActive: Bool

    private var normalizedAngle: Double {
        let clamped = max(minAngle, min(maxAngle, angle))
        return (clamped - minAngle) / (maxAngle - minAngle)
    }

    var body: some View {
        VStack(spacing: LidonicaTheme.spacingSM) {
            arcGauge
            angleLabel
        }
    }

    private var arcGauge: some View {
        ZStack {
            // Track arc
            ArcShape(startAngle: .degrees(180), endAngle: .degrees(360))
                .stroke(LidonicaTheme.gaugeTrack, style: StrokeStyle(lineWidth: 6, lineCap: .round))

            // Active arc
            ArcShape(
                startAngle: .degrees(180),
                endAngle: .degrees(180 + normalizedAngle * 180)
            )
            .stroke(
                isActive ? LidonicaTheme.gaugeActive : LidonicaTheme.textTertiary,
                style: StrokeStyle(lineWidth: 6, lineCap: .round)
            )
            .animation(.easeOut(duration: 0.1), value: normalizedAngle)

            // Needle indicator
            Circle()
                .fill(isActive ? LidonicaTheme.gaugeActive : LidonicaTheme.textTertiary)
                .frame(width: 10, height: 10)
                .offset(needleOffset)
                .animation(.easeOut(duration: 0.1), value: normalizedAngle)
        }
        .padding(.horizontal, 8)
    }

    private var needleOffset: CGSize {
        let gaugeAngle = Angle.degrees(180 + normalizedAngle * 180)
        let radius: Double = 50
        return CGSize(
            width: cos(gaugeAngle.radians) * radius,
            height: sin(gaugeAngle.radians) * radius
        )
    }

    private var angleLabel: some View {
        Text("\(Int(angle))°")
            .font(LidonicaTheme.monoFont)
            .foregroundStyle(isActive ? LidonicaTheme.textPrimary : LidonicaTheme.textTertiary)
    }
}

struct ArcShape: Shape {
    var startAngle: Angle
    var endAngle: Angle

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle.degrees, endAngle.degrees) }
        set {
            startAngle = .degrees(newValue.first)
            endAngle = .degrees(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY - 4)
        let radius = min(rect.width, rect.height * 2) / 2 - 6
        path.addArc(center: center, radius: radius,
                    startAngle: startAngle, endAngle: endAngle,
                    clockwise: false)
        return path
    }
}
