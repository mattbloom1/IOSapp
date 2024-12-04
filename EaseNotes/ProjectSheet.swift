extension View {
    @ViewBuilder public func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

import SwiftUI
import UserNotifications

struct ProjectSheet: View {
    @Bindable var project: Project
    @FocusState private var isDescriptionFocused: Bool
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var timerManager = ProjectTimer()

    @State private var selectedInterval = 5 // Default interval in minutes

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $project.title)
                    .font(.headline)
                    .padding()

                Divider()
                    .padding()

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $project.content)
                        .padding(.horizontal)
                        .focused($isDescriptionFocused)

                    Text("Project Description")
                        .fontWeight(.light)
                        .foregroundColor(.black.opacity(0.25))
                        .padding(.horizontal)
                        .hidden(isDescriptionFocused || !$project.wrappedValue.content.isEmpty)
                }

                Divider()
                    .padding()

                // Timer Section
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Enable Timer", isOn: $project.isTimerActive)
                        .onChange(of: project.isTimerActive) {
                            if project.isTimerActive {
                                timerManager.start(interval: TimeInterval(selectedInterval))
                                project.remainingTime = Int(timerManager.remainingTime)
                            } else {
                                timerManager.stop()
                                project.remainingTime = nil
                            }
                        }

                    if project.isTimerActive {
                        Picker("Interval (minutes)", selection: $selectedInterval) {
                            ForEach([5, 10, 15, 30, 60], id: \.self) { interval in
                                Text("\(interval) min").tag(interval)
                            }
                        }
                        .pickerStyle(.menu)

                        Text("Time Remaining: \(Int(timerManager.remainingTime) / 60)m \(Int(timerManager.remainingTime) % 60)s")
                            .font(.caption)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(width: 100, height: 40)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .gray, radius: 5)
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        // Save timer state to the database
                        project.timerInterval = selectedInterval
                        project.remainingTime = Int(timerManager.remainingTime)
                        context.insert(project)
                        dismiss()
                    }) {
                        Text("Save")
                            .frame(width: 100, height: 40)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .gray, radius: 5)
                    }
                }
            }
        }
        .onReceive(timerManager.$remainingTime) { newTime in
            project.remainingTime = Int(newTime)
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: ProjectTimer.timerDidComplete, object: nil, queue: .main) { _ in
                promptForUpdate()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: ProjectTimer.timerDidComplete, object: nil)
        }
    }

    private func promptForUpdate() {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        let newUpdate = "Update at \(timestamp):\n"
        project.content.append("\n\(newUpdate)")
        isDescriptionFocused = true // Automatically focus the text editor for the user to type
    }
}

#Preview {
    ProjectSheet(project: Project(title: "", description: "", createdAt: Date.now))
}
