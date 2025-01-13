import SwiftUI
import Combine

class GameTimer: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var isActive: Bool = false
    @Published var hasExpired: Bool = false

    private var timer: AnyCancellable?

    func startTimer(duration: TimeInterval) {
        remainingTime = duration
        isActive = true
        hasExpired = false

        timer?.cancel()
        timer = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func stopTimer() {
        isActive = false
        timer?.cancel()
    }
    
    func resetTimer(duration: TimeInterval) {
        stopTimer()
        hasExpired = false
        remainingTime = duration
    }

    private func tick() {
        guard remainingTime > 0.01 else {
            timer?.cancel()
            isActive = false
            hasExpired = true
            return
        }
        remainingTime -= 0.01
    }
}
