import UIKit

class BackgroundTaskHandler {
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

    func startBackgroundTask() {
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }

    func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
}
