import Foundation
import SwiftData

@Model
final class CoachTask {
    @Attribute(.unique) var id: UUID
    var goalId: UUID
    var title: String
    var taskDescription: String?
    var dueDate: Date?
    var isCompleted: Bool
    var completedDate: Date?
    var createdByCoach: Bool
    var createdDuringConversationId: UUID?
    var relatedToRunId: UUID?
    var category: String // "gear", "nutrition", "hydration", "scheduling", "recovery", "other"
    var priority: String // "high", "medium", "low"
    var createdAt: Date

    init(
        id: UUID = UUID(),
        goalId: UUID,
        title: String,
        taskDescription: String? = nil,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        completedDate: Date? = nil,
        createdByCoach: Bool = false,
        createdDuringConversationId: UUID? = nil,
        relatedToRunId: UUID? = nil,
        category: String = "other",
        priority: String = "medium",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.goalId = goalId
        self.title = title
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.createdByCoach = createdByCoach
        self.createdDuringConversationId = createdDuringConversationId
        self.relatedToRunId = relatedToRunId
        self.category = category
        self.priority = priority
        self.createdAt = createdAt
    }

    // Computed properties
    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }

    var daysUntilDue: Int? {
        guard let dueDate = dueDate, !isCompleted else { return nil }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: dueDate).day
        return days
    }
}
