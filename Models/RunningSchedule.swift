import Foundation
import SwiftData

@Model
final class RunningSchedule {
    @Attribute(.unique) var id: UUID
    var goalId: UUID
    var startDate: Date
    var endDate: Date?
    var weeklyFrequency: Int // 2, 3, 4, 5 runs per week
    var fitnessLevel: String // "beginner", "intermediate", "advanced"
    var targetRaceDistance: Double? // kilometers (e.g., 21.1 for half marathon)
    var targetRaceDate: Date?
    var currentWeek: Int
    var isActive: Bool
    var version: Int // Increments when schedule is adapted
    var createdAt: Date
    var lastAdaptedAt: Date?

    @Relationship(deleteRule: .cascade) var scheduledRuns: [ScheduledRun]?

    init(
        id: UUID = UUID(),
        goalId: UUID,
        startDate: Date = Date(),
        endDate: Date? = nil,
        weeklyFrequency: Int,
        fitnessLevel: String,
        targetRaceDistance: Double? = nil,
        targetRaceDate: Date? = nil,
        currentWeek: Int = 1,
        isActive: Bool = true,
        version: Int = 1,
        createdAt: Date = Date(),
        lastAdaptedAt: Date? = nil
    ) {
        self.id = id
        self.goalId = goalId
        self.startDate = startDate
        self.endDate = endDate
        self.weeklyFrequency = weeklyFrequency
        self.fitnessLevel = fitnessLevel
        self.targetRaceDistance = targetRaceDistance
        self.targetRaceDate = targetRaceDate
        self.currentWeek = currentWeek
        self.isActive = isActive
        self.version = version
        self.createdAt = createdAt
        self.lastAdaptedAt = lastAdaptedAt
    }

    // Computed properties
    var totalWeeks: Int? {
        guard let endDate = endDate else { return nil }
        let calendar = Calendar.current
        let weeks = calendar.dateComponents([.weekOfYear], from: startDate, to: endDate).weekOfYear
        return weeks
    }

    var weeksRemaining: Int? {
        guard let endDate = endDate else { return nil }
        let calendar = Calendar.current
        let weeks = calendar.dateComponents([.weekOfYear], from: Date(), to: endDate).weekOfYear
        return max(0, weeks ?? 0)
    }

    var upcomingRuns: [ScheduledRun] {
        scheduledRuns?.filter {
            $0.scheduledDateTime > Date() && $0.status == "scheduled"
        }.sorted {
            $0.scheduledDateTime < $1.scheduledDateTime
        } ?? []
    }

    var nextRun: ScheduledRun? {
        upcomingRuns.first
    }

    var completedRuns: [ScheduledRun] {
        scheduledRuns?.filter { $0.status == "completed" } ?? []
    }

    var completionRate: Double {
        guard let runs = scheduledRuns, !runs.isEmpty else { return 0.0 }
        let pastRuns = runs.filter { $0.isPast }
        guard !pastRuns.isEmpty else { return 0.0 }
        let completed = pastRuns.filter { $0.isCompleted }.count
        return Double(completed) / Double(pastRuns.count)
    }
}
