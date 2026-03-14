import Foundation
import Combine

final class SliderLidSensor: LidAngleProvider {
    let angle = CurrentValueSubject<Double, Never>(105)
    let isAvailable: Bool = true

    private let smoother = AngleSmoothing()

    func start() {
        // Slider-driven — updates come from setAngle calls
    }

    func stop() {
        // No cleanup needed
    }

    func setAngle(_ rawAngle: Double) {
        let smoothed = smoother.smooth(rawAngle)
        angle.send(smoothed)
    }
}
