import Foundation
import Combine

enum TimerState {
    case idle, running, paused, finished
}

final class CounterViewModel: ObservableObject {

    // MARK: - Picker
    @Published var selectedHours: Int = 0
    @Published var selectedMinutes: Int = 1
    @Published var selectedSeconds: Int = 0

    // MARK: - Runtime
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var state: TimerState = .idle

    private var cancellable: AnyCancellable?

    // MARK: - Computed

    var isActive: Bool   { state == .running || state == .paused }
    var isRunning: Bool  { state == .running }
    var isPaused: Bool   { state == .paused }
    var isFinished: Bool { state == .finished }

    var isConfigured: Bool {
        selectedHours > 0 || selectedMinutes > 0 || selectedSeconds > 0
    }

    var progress: Double {
        guard totalSeconds > 0 else { return 1.0 }
        return Double(remainingSeconds) / Double(totalSeconds)
    }

    var timeString: String {
        let h = remainingSeconds / 3600
        let m = (remainingSeconds % 3600) / 60
        let s = remainingSeconds % 60
        if h > 0 { return String(format: "%d:%02d:%02d", h, m, s) }
        return String(format: "%02d:%02d", m, s)
    }

    var elapsedString: String {
        let elapsed = totalSeconds - remainingSeconds
        let m = elapsed / 60
        let s = elapsed % 60
        return String(format: "%02d:%02d elapsed", m, s)
    }

    // MARK: - Actions

    func start() {
        totalSeconds = selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds
        remainingSeconds = totalSeconds
        state = .running
        beginCounting()
    }

    func pause() {
        state = .paused
        cancellable?.cancel()
    }

    func resume() {
        state = .running
        beginCounting()
    }

    func cancel() {
        cancellable?.cancel()
        state = .idle
        remainingSeconds = 0
        totalSeconds = 0
    }

    func restart() {
        cancel()
        // restore picker to last used duration
    }

    // MARK: - Private

    private func beginCounting() {
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.state = .finished
                    self.cancellable?.cancel()
                }
            }
    }
}
