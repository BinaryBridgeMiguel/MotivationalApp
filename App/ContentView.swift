import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var dataService: DataService

    var body: some View {
        Group {
            if dataService.currentUser != nil {
                HomeView()
            } else {
                WelcomeView()
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: User.self, Goal.self, DailyProgress.self, ConversationSession.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    return ContentView()
        .environmentObject(DataService(modelContainer: container))
        .modelContainer(container)
}
