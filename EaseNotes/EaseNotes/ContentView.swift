import SwiftUI
import SwiftData
import UserNotifications

struct ContentView: View {
    @State private var projects = Project.emptyList
    @State private var isShowingSheet = false
    @State private var selectedProject: Project = Project(title: "", description: "")
    @Environment(\.modelContext) var context
    
    @Query(sort: \Project.title) var swiftDataProjects: [Project]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(
                            LinearGradient(gradient:
                                            Gradient(colors: [
                                                Color.green.opacity(0.8),
                                                Color.black.opacity(0.5),
                                                Color.green.opacity(0.7),
                                                Color.black.opacity(0.8),
                                            ]), startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .frame(height: geometry.size.height / 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(Color.white.opacity(0.4))
                                .frame(height: 100)
                                .overlay(
                                    HStack {
                                        VStack(alignment: .leading, spacing: 15) {
                                            Text("Welcome To DocuEase")
                                                .font(.system(size: 24, weight: .bold))
                                            Text("DocuEase is a ....")
                                                .font(.subheadline)
                                        }
                                        Image(systemName: "applepencil.and.scribble")
                                            .imageScale(.large)
                                            .font(.system(size: 40))
                                    }
                                    .padding()
                                )
                                .padding()
                                .foregroundColor(.white)
                        )
                    ForEach(swiftDataProjects) { project in
                        ProjectRow(project: project)
                            .onTapGesture {
                                selectedProject = project
                                isShowingSheet = true
                            }
                            .contextMenu {
                                Button(action: {
                                    context.delete(project)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                ProjectSheet(project: selectedProject)
                    .presentationDetents([.fraction(0.75), .large])
            }
            .background(Color.gray.opacity(0.3))
            .overlay {
                if swiftDataProjects.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label {
                                Text("No Projects")
                            } icon: {
                                Image(systemName: "doc.plaintext")
                                    .foregroundColor(Color.green)
                            }
                        }
                    )
                    .offset(y: 100)
                }
            }
            .overlay(
                HStack {
                    Spacer()
                    Button(action: { isShowingSheet = true }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(
                                color: Color.green,
                                radius: 15
                            )
                    }
                }
                .padding(),
                alignment: .bottomTrailing
            )
            .onAppear {
                requestNotificationPermissions()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }
}

#Preview {
    ContentView()
}
