import Foundation
import Combine

protocol LidAngleProvider: AnyObject {
    var angle: CurrentValueSubject<Double, Never> { get }
    var isAvailable: Bool { get }
    func start()
    func stop()
}

final class AngleSmoothing {
    private var smoothedValue: Double
    private let factor: Double

    init(initialValue: Double = 105, smoothingFactor: Double = 0.3) {
        self.smoothedValue = initialValue
        self.factor = smoothingFactor
    }

    func smooth(_ rawValue: Double) -> Double {
        smoothedValue = smoothedValue + factor * (rawValue - smoothedValue)
        return smoothedValue
    }

    func reset(to value: Double) {
        smoothedValue = value
    }
}
