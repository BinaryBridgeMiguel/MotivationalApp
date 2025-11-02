import Foundation
import SwiftData

@Model
final class Goal {
    @Attribute(.unique) var id: UUID
    var goalText: String
    var whyItMatters: String
    var biggestObstacle: String
    var struggleTime: String
    var createdAt: Date
    var isActive: Bool

    @Relationship(deleteRule: .nullify, inverse: \User.goals) var user: User?
    @Relationship(deleteRule: .cascade) var dailyProgress: [DailyProgress]?

    init(
        id: UUID = UUID(),
        goalText: String,
        whyItMatters: String,
        biggestObstacle: String,
        struggleTime: String,
        createdAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.goalText = goalText
        self.whyItMatters = whyItMatters
        self.biggestObstacle = biggestObstacle
        self.struggleTime = struggleTime
        self.createdAt = createdAt
        self.isActive = isActive
    }

    // Helper computed properties
    var currentStreak: Int {
        guard let progress = dailyProgress else { return 0 }

        let sortedProgress = progress
            .filter { $0.completed }
            .sorted { $0.date > $1.date }

        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())

        for record in sortedProgress {
            let recordDate = Calendar.current.startOfDay(for: record.date)
            if recordDate == currentDate {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else if recordDate < currentDate {
                break
            }
        }

        return streak
    }

    var completionsThisWeek: Int {
        guard let progress = dailyProgress else { return 0 }

        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()

        return progress.filter { record in
            record.completed && record.date >= startOfWeek
        }.count
    }
}
