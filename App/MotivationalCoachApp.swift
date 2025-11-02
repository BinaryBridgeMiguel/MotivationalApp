import SwiftUI
import SwiftData

@main
struct MotivationalCoachApp: App {
    @StateObject private var notificationService = NotificationService()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Goal.self,
            DailyProgress.self,
            ConversationSession.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environmentObject(DataService(modelContainer: sharedModelContainer))
                .environmentObject(notificationService)
                .onAppear {
                    notificationService.setupNotificationCategories()
                }
        }
    }
}
