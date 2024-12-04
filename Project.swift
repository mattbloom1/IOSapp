import SwiftUI
import Foundation
import SwiftData

@Model
final class Project: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var createdAt: Date
    var timerInterval: Int? // Timer interval in minutes
    var isTimerActive: Bool = false // Tracks if the timer is running
    var remainingTime: Int? // Remaining time in seconds

    init(id: UUID = UUID(), title: String, description: String, createdAt: Date = Date(), timerInterval: Int? = nil, isTimerActive: Bool = false, remainingTime: Int? = nil) {
        self.id = id
        self.title = title
        self.content = description
        self.createdAt = createdAt
        self.timerInterval = timerInterval
        self.isTimerActive = isTimerActive
        self.remainingTime = remainingTime
    }
}

extension Project {
    // Provides an empty list of projects for initial app state
    static var emptyList: [Project] { [] }

    // Provides mock data for testing or prototyping
    static var mockData: [Project] {
        [
            Project(title: "Portfolio Website", description: "A personal website to showcase my design and development projects, built with HTML, CSS, and JavaScript.", createdAt: Date().addingTimeInterval(-150000)),
            Project(title: "Smart To-Do List", description: "A to-do list app that uses Swift and CoreData to manage tasks efficiently, featuring priority tags and reminders.", createdAt: Date().addingTimeInterval(-200000)),
            Project(title: "Rock Climbing Logbook", description: "An app to log and track rock climbing sessions, routes, and progress, using Swift and CloudKit for syncing.", createdAt: Date().addingTimeInterval(-250000)),
            Project(title: "Interactive Resume", description: "An interactive PDF resume designed in Figma, showcasing my skills, experience, and projects with visual storytelling.", createdAt: Date().addingTimeInterval(-300000)),
            Project(title: "Digital Art Portfolio", description: "A curated collection of digital illustrations and artwork, organized into categories and shared through an online gallery.", createdAt: Date().addingTimeInterval(-350000))
        ]
    }
}
