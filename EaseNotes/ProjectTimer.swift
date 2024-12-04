import Foundation
import UserNotifications
import UIKit

class ProjectTimer: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var isRunning = false

    private var timer: Timer?
    private var totalInterval: TimeInterval = 0
    private let backgroundTaskHandler = BackgroundTaskHandler()

    // Completion handler for timer events
    var onTimerComplete: (() -> Void)?

    // Unique identifier for the notification
    private var notificationIdentifier: String = UUID().uuidString

    func start(interval: TimeInterval, autoRestart: Bool = true) {
        stop() // Stop any existing timer
        totalInterval = interval * 60
        remainingTime = totalInterval
        isRunning = true

        backgroundTaskHandler.startBackgroundTask()

        // Schedule a notification for timer completion
        scheduleNotification(in: totalInterval)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.stop()
                self.onTimerComplete?()
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

        // Cancel any pending notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }

    private func scheduleNotification(in timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Timer Completed"
        content.body = "Time to document your progress!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
