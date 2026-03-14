import AVFoundation
import Foundation

final class ToneGenerator {
    private let sampleRate: Double
    private var phase: Double = 0
    private var targetFrequency: Double = 0
    private var currentFrequency: Double = 0
    private var waveform: Waveform = .sine

    // ADSR envelope
    private var envelope: Double = 0
    private var envelopeState: EnvelopeState = .idle
    private let attackTime: Double = 0.02
    private let decayTime: Double = 0.05
    private let sustainLevel: Double = 0.7
    private let releaseTime: Double = 0.15

    // Portamento
    private let portamentoRate: Double = 0.05

    private enum EnvelopeState {
        case idle, attack, decay, sustain, release
    }

    init(sampleRate: Double) {
        self.sampleRate = sampleRate
    }

    func noteOn(frequency: Double, waveform: Waveform) {
        self.targetFrequency = frequency
        self.waveform = waveform
        if envelopeState == .idle {
            currentFrequency = frequency
        }
        envelopeState = .attack
    }

    func noteOff() {
        envelopeState = .release
    }

    func render(buffer: UnsafeMutablePointer<Float>, frameCount: Int) {
        for i in 0 ..< frameCount {
            currentFrequency += (targetFrequency - currentFrequency) * portamentoRate

            updateEnvelope()

            let sample = generateSample(phase: phase, waveform: waveform)
            buffer[i] = Float(sample * envelope)

            let phaseIncrement = currentFrequency / sampleRate
            phase += phaseIncrement
            if phase >= 1.0 { phase -= 1.0 }
        }
    }

    private func generateSample(phase: Double, waveform: Waveform) -> Double {
        switch waveform {
        case .sine:
            return sin(phase * 2.0 * .pi)
        case .triangle:
            let t = phase
            return t < 0.5 ? (4.0 * t - 1.0) : (3.0 - 4.0 * t)
        case .softSaw:
            // Band-limited approximation using harmonics for a softer sound
            var sample = 0.0
            for k in 1...6 {
                let harmonic = Double(k)
                sample += pow(-1, harmonic + 1) * sin(phase * 2.0 * .pi * harmonic) / harmonic
            }
            return sample * 0.5
        }
    }

    private func updateEnvelope() {
        let step = 1.0 / sampleRate

        switch envelopeState {
        case .idle:
            envelope = 0
        case .attack:
            envelope += step / attackTime
            if envelope >= 1.0 {
                envelope = 1.0
                envelopeState = .decay
            }
        case .decay:
            envelope -= step / decayTime * (1.0 - sustainLevel)
            if envelope <= sustainLevel {
                envelope = sustainLevel
                envelopeState = .sustain
            }
        case .sustain:
            envelope = sustainLevel
        case .release:
            envelope -= step / releaseTime * sustainLevel
            if envelope <= 0 {
                envelope = 0
                envelopeState = .idle
            }
        }
    }
}
