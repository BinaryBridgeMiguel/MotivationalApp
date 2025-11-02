import Foundation
import SwiftData

@MainActor
class DataService: ObservableObject {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @Published var currentUser: User?
    @Published var activeGoal: Goal?

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = modelContainer.mainContext
        loadCurrentUser()
    }

    // MARK: - User Management

    private func loadCurrentUser() {
        let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        if let users = try? modelContext.fetch(descriptor), let user = users.first {
            currentUser = user
            loadActiveGoal()
        }
    }

    func createUser(name: String) {
        let user = User(name: name)
        modelContext.insert(user)
        try? modelContext.save()
        currentUser = user
    }

    // MARK: - Goal Management

    private func loadActiveGoal() {
        guard let user = currentUser else { return }

        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate<Goal> { goal in
                goal.isActive == true
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        if let goals = try? modelContext.fetch(descriptor), let goal = goals.first {
            activeGoal = goal
        }
    }

    func createGoal(
        goalText: String,
        whyItMatters: String,
        biggestObstacle: String,
        struggleTime: String
    ) {
        guard let user = currentUser else { return }

        // Deactivate existing goals
        if let existingGoals = user.goals {
            for goal in existingGoals {
                goal.isActive = false
            }
        }

        let goal = Goal(
            goalText: goalText,
            whyItMatters: whyItMatters,
            biggestObstacle: biggestObstacle,
            struggleTime: struggleTime
        )
        goal.user = user
        modelContext.insert(goal)
        try? modelContext.save()

        activeGoal = goal
    }

    // MARK: - Progress Tracking

    func recordDailyProgress(completed: Bool, notes: String? = nil) {
        guard let goal = activeGoal else { return }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Check if progress already exists for today
        if let existingProgress = goal.dailyProgress?.first(where: {
            calendar.isDate($0.date, inSameDayAs: today)
        }) {
            existingProgress.completed = completed
            existingProgress.notes = notes
        } else {
            let progress = DailyProgress(date: today, completed: completed, notes: notes)
            progress.goal = goal
            modelContext.insert(progress)
        }

        try? modelContext.save()
    }

    func getTodayProgress() -> DailyProgress? {
        guard let goal = activeGoal else { return nil }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return goal.dailyProgress?.first(where: {
            calendar.isDate($0.date, inSameDayAs: today)
        })
    }

    // MARK: - Conversation Management

    func startConversationSession() -> ConversationSession {
        guard let user = currentUser else {
            fatalError("No user found")
        }

        let session = ConversationSession()
        session.user = user
        modelContext.insert(session)
        try? modelContext.save()

        return session
    }

    func endConversationSession(_ session: ConversationSession, transcript: String? = nil) {
        session.endTime = Date()
        session.transcript = transcript
        try? modelContext.save()
    }
}
