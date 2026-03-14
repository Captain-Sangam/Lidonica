import AVFoundation
import Foundation

final class AudioEngine {
    private let engine = AVAudioEngine()
    private let reverb = AVAudioUnitReverb()
    private var sourceNode: AVAudioSourceNode?
    private var toneGenerator: ToneGenerator?
    private var isRunning = false
    private var currentMidiNote: Int?

    private let stereoFormat: AVAudioFormat

    init() {
        let sampleRate = 44100.0
        stereoFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!
        toneGenerator = ToneGenerator(sampleRate: sampleRate)
        setupAudioGraph()
    }

    private func setupAudioGraph() {
        guard let toneGenerator = toneGenerator else { return }

        let srcNode = AVAudioSourceNode(format: stereoFormat) { _, _, frameCount, bufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(bufferList)
            let count = Int(frameCount)

            // Render mono into a temp buffer, then copy to both channels
            var mono = [Float](repeating: 0, count: count)
            toneGenerator.render(buffer: &mono, frameCount: count)

            for buf in ablPointer {
                guard let dest = buf.mData?.assumingMemoryBound(to: Float.self) else { continue }
                for i in 0..<count {
                    dest[i] = mono[i]
                }
            }
            return noErr
        }

        sourceNode = srcNode

        engine.attach(srcNode)
        engine.attach(reverb)

        reverb.loadFactoryPreset(.smallRoom)
        reverb.wetDryMix = 25

        engine.connect(srcNode, to: reverb, format: stereoFormat)
        engine.connect(reverb, to: engine.mainMixerNode, format: stereoFormat)

        engine.mainMixerNode.outputVolume = 0.7
    }

    func start() {
        guard !isRunning else { return }
        do {
            try engine.start()
            isRunning = true
        } catch {
            print("AudioEngine failed to start: \(error)")
        }
    }

    func stop() {
        guard isRunning else { return }
        toneGenerator?.noteOff()
        engine.stop()
        isRunning = false
        currentMidiNote = nil
    }

    func playNote(midiNote: Int, waveform: Waveform, reverbMix: Float) {
        guard isRunning else { return }
        let frequency = Note.frequency(for: midiNote)
        reverb.wetDryMix = reverbMix * 100
        toneGenerator?.noteOn(frequency: frequency, waveform: waveform)
        currentMidiNote = midiNote
    }

    func stopNote() {
        toneGenerator?.noteOff()
        currentMidiNote = nil
    }

    func setVolume(_ volume: Float) {
        engine.mainMixerNode.outputVolume = volume
    }
}
