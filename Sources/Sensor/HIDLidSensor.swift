import Foundation
import Combine
import IOKit
import IOKit.hid

final class HIDLidSensor: LidAngleProvider {
    let angle = CurrentValueSubject<Double, Never>(105)
    private(set) var isAvailable: Bool = false

    private var device: IOHIDDevice?
    private var timer: DispatchSourceTimer?
    private let smoother = AngleSmoothing()
    private let queue = DispatchQueue(label: "com.lidonica.hid-sensor", qos: .userInteractive)

    init() {
        device = findSensor()
        isAvailable = device != nil
    }

    func start() {
        guard let device = device else { return }

        if IOHIDDeviceOpen(device, IOOptionBits(kIOHIDOptionsTypeNone)) != kIOReturnSuccess {
            isAvailable = false
            return
        }

        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(33))
        timer.setEventHandler { [weak self] in
            self?.pollAngle()
        }
        timer.resume()
        self.timer = timer
    }

    func stop() {
        timer?.cancel()
        timer = nil
        if let device = device {
            IOHIDDeviceClose(device, IOOptionBits(kIOHIDOptionsTypeNone))
        }
    }

    private func pollAngle() {
        guard let device = device else { return }

        var report = [UInt8](repeating: 0, count: 8)
        var length = report.count as CFIndex

        let result = IOHIDDeviceGetReport(
            device,
            kIOHIDReportTypeFeature,
            1,
            &report,
            &length
        )

        guard result == kIOReturnSuccess, length >= 3 else { return }

        let rawAngle = Int(report[2]) << 8 | Int(report[1])
        guard rawAngle > 1 else { return }

        let smoothed = smoother.smooth(Double(rawAngle))
        angle.send(smoothed)
    }

    private func findSensor() -> IOHIDDevice? {
        let matchSets: [[String: Int]] = [
            ["VendorID": 0x05AC, "ProductID": 0x8104, "PrimaryUsagePage": 0x0020, "PrimaryUsage": 0x008A],
            ["VendorID": 0x05AC, "PrimaryUsagePage": 0x0020, "PrimaryUsage": 0x008A],
            ["PrimaryUsagePage": 0x0020, "PrimaryUsage": 0x008A],
        ]

        for matchDict in matchSets {
            if let device = findDevice(matching: matchDict) {
                return device
            }
        }
        return nil
    }

    private func findDevice(matching criteria: [String: Int]) -> IOHIDDevice? {
        let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))

        guard IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone)) == kIOReturnSuccess else {
            return nil
        }

        let cfDict = criteria.reduce(into: NSMutableDictionary()) { dict, pair in
            dict[pair.key] = pair.value
        } as CFDictionary

        IOHIDManagerSetDeviceMatching(manager, cfDict)

        guard let devices = IOHIDManagerCopyDevices(manager) as? Set<IOHIDDevice>,
              !devices.isEmpty else {
            IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
            return nil
        }

        for testDevice in devices {
            if IOHIDDeviceOpen(testDevice, IOOptionBits(kIOHIDOptionsTypeNone)) == kIOReturnSuccess {
                var report = [UInt8](repeating: 0, count: 8)
                var length = report.count as CFIndex

                let result = IOHIDDeviceGetReport(
                    testDevice,
                    kIOHIDReportTypeFeature,
                    1,
                    &report,
                    &length
                )

                IOHIDDeviceClose(testDevice, IOOptionBits(kIOHIDOptionsTypeNone))

                if result == kIOReturnSuccess && length >= 3 {
                    return testDevice
                }
            }
        }

        IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        return nil
    }

    deinit {
        stop()
    }
}
