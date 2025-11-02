import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var dataService: DataService

    init() {
        // Note: This is a workaround for initializing DataService with environment
        // In actual implementation, you may need to handle this differently
        let container = try! ModelContainer(
            for: User.self, Goal.self, DailyProgress.self, ConversationSession.self
        )
        _dataService = StateObject(wrappedValue: DataService(modelContainer: container))
    }

    var body: some View {
        Group {
            if dataService.currentUser != nil {
                HomeView()
            } else {
                WelcomeView()
            }
        }
        .environmentObject(dataService)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Goal.self, DailyProgress.self, ConversationSession.self], inMemory: true)
}
