import SwiftUI
import SwiftData

@main
struct MotivationalCoachApp: App {
    @StateObject private var notificationService: NotificationService = {
        let service = NotificationService()
        service.setupNotificationCategories()
        return service
    }()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Goal.self,
            DailyProgress.self,
            ConversationSession.self,
            RunningSchedule.self,
            ScheduledRun.self,
            RunSession.self,
            CoachTask.self,
            Milestone.self
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
        }
    }
}
