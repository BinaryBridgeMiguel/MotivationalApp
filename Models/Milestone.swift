import Foundation
import SwiftData

@Model
final class Milestone {
    @Attribute(.unique) var id: UUID
    var goalId: UUID
    var title: String
    var milestoneDescription: String?
    var targetDistance: Double? // kilometers
    var targetDate: Date?
    var isCompleted: Bool
    var completedDate: Date?
    var celebrationCallScheduled: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        goalId: UUID,
        title: String,
        milestoneDescription: String? = nil,
        targetDistance: Double? = nil,
        targetDate: Date? = nil,
        isCompleted: Bool = false,
        completedDate: Date? = nil,
        celebrationCallScheduled: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.goalId = goalId
        self.title = title
        self.milestoneDescription = milestoneDescription
        self.targetDistance = targetDistance
        self.targetDate = targetDate
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.celebrationCallScheduled = celebrationCallScheduled
        self.createdAt = createdAt
    }

    // Computed properties
    var daysUntilTarget: Int? {
        guard let targetDate = targetDate, !isCompleted else { return nil }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: Date(), to: targetDate).day
        return days
    }

    var isPastDue: Bool {
        guard let targetDate = targetDate, !isCompleted else { return false }
        return targetDate < Date()
    }
}
