import AVFoundation

/// Low-latency player. Every clip is decoded into memory at launch and played
/// through a single always-running AVAudioEngine node, so a tap only has to
/// schedule an already-decoded buffer. A new tap interrupts the previous clip,
/// so the latest letter touched is always the one heard.
final class SoundPlayer {
    static let shared = SoundPlayer()

    private let engine = AVAudioEngine()
    private let node = AVAudioPlayerNode()
    private var buffers: [String: AVAudioPCMBuffer] = [:]
    private var prepared = false

    private init() {}

    func prepare(_ names: [String]) {
        guard !prepared else { return }
        prepared = true
        let session = AVAudioSession.sharedInstance()
        // .playback: still plays when the silent switch is on.
        try? session.setCategory(.playback, mode: .default)
        try? session.setPreferredIOBufferDuration(0.005)
        try? session.setActive(true)

        var format: AVAudioFormat?
        for name in names {
            guard let url = Bundle.main.url(forResource: name, withExtension: "caf"),
                  let file = try? AVAudioFile(forReading: url),
                  let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat,
                                                frameCapacity: AVAudioFrameCount(file.length))
            else { continue }
            try? file.read(into: buffer)
            buffers[name] = buffer
            format = file.processingFormat
        }

        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        engine.prepare()
        start()

        let nc = NotificationCenter.default
        nc.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] _ in
            self?.start()
        }
        nc.addObserver(forName: .AVAudioEngineConfigurationChange, object: engine, queue: .main) { [weak self] _ in
            self?.start()
        }
        nc.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification, object: nil, queue: .main) { [weak self] _ in
            self?.start()
        }
    }

    func start() {
        guard !engine.isRunning else { return }
        try? AVAudioSession.sharedInstance().setActive(true)
        try? engine.start()
        node.play()
    }

    func play(_ name: String) {
        guard let buffer = buffers[name] else { return }
        if !engine.isRunning { start() }
        node.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        if !node.isPlaying { node.play() }
    }
}
