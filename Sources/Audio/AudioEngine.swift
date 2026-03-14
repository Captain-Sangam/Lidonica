import AVFoundation
import Foundation

final class AudioEngine {
    private let engine = AVAudioEngine()
    private let reverb = AVAudioUnitReverb()
    private var sourceNode: AVAudioSourceNode?
    private var toneGenerator: ToneGenerator?
    private var isRunning = false
    private var currentMidiNote: Int?

    private let format: AVAudioFormat

    init() {
        let sampleRate = 44100.0
        format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        toneGenerator = ToneGenerator(sampleRate: sampleRate)
        setupAudioGraph()
    }

    private func setupAudioGraph() {
        guard let toneGenerator = toneGenerator else { return }

        let srcNode = AVAudioSourceNode(format: format) { _, _, frameCount, bufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(bufferList)
            guard let buffer = ablPointer.first?.mData?.assumingMemoryBound(to: Float.self) else {
                return noErr
            }
            toneGenerator.render(buffer: buffer, frameCount: Int(frameCount))
            return noErr
        }

        sourceNode = srcNode

        engine.attach(srcNode)
        engine.attach(reverb)

        reverb.loadFactoryPreset(.smallRoom)
        reverb.wetDryMix = 25

        engine.connect(srcNode, to: reverb, format: format)
        engine.connect(reverb, to: engine.mainMixerNode, format: format)

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
