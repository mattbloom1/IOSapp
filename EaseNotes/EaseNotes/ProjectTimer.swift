import Foundation
import UserNotifications
import UIKit

class ProjectTimer: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var isRunning = false

    private var timer: Timer?
    private var totalInterval: TimeInterval = 0
    private let backgroundTaskHandler = BackgroundTaskHandler()

    func start(interval: TimeInterval, autoRestart: Bool = true) {
        stop() // Ensure no duplicate timers
        totalInterval = interval * 60 // Convert minutes to seconds
        remainingTime = totalInterval
        isRunning = true

        // Start background task
        backgroundTaskHandler.startBackgroundTask()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.stop()
                self.notifyTimerEnd()
                if autoRestart {
                    self.start(interval: interval, autoRestart: autoRestart)
                }
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingTime = 0
        backgroundTaskHandler.endBackgroundTask()
    }

    private func notifyTimerEnd() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Completed"
        content.body = "Time to document your progress!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }
}
