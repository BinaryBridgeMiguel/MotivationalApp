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

    // Running-specific fields
    var fitnessLevel: String? // "beginner", "intermediate", "advanced"
    var weeklyFrequency: Int? // 2, 3, 4, 5 runs per week
    var targetRaceDistance: Double? // kilometers
    var targetRaceDate: Date?
    var obstacleCategories: [String]? // ["motivation", "time", "weather", "injury"]

    @Relationship(deleteRule: .nullify, inverse: \User.goals) var user: User?
    @Relationship(deleteRule: .cascade) var dailyProgress: [DailyProgress]?
    @Relationship(deleteRule: .cascade) var runningSchedule: RunningSchedule?
    @Relationship(deleteRule: .cascade) var tasks: [CoachTask]?
    @Relationship(deleteRule: .cascade) var milestones: [Milestone]?
    @Relationship(deleteRule: .cascade) var runSessions: [RunSession]?

    init(
        id: UUID = UUID(),
        goalText: String,
        whyItMatters: String,
        biggestObstacle: String,
        struggleTime: String,
        createdAt: Date = Date(),
        isActive: Bool = true,
        fitnessLevel: String? = nil,
        weeklyFrequency: Int? = nil,
        targetRaceDistance: Double? = nil,
        targetRaceDate: Date? = nil,
        obstacleCategories: [String]? = nil
    ) {
        self.id = id
        self.goalText = goalText
        self.whyItMatters = whyItMatters
        self.biggestObstacle = biggestObstacle
        self.struggleTime = struggleTime
        self.createdAt = createdAt
        self.isActive = isActive
        self.fitnessLevel = fitnessLevel
        self.weeklyFrequency = weeklyFrequency
        self.targetRaceDistance = targetRaceDistance
        self.targetRaceDate = targetRaceDate
        self.obstacleCategories = obstacleCategories
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

    // Running-specific computed properties
    var totalRunsCompleted: Int {
        runSessions?.count ?? 0
    }

    var totalDistanceRun: Double {
        runSessions?.compactMap { $0.actualDistance }.reduce(0, +) ?? 0.0
    }

    var averageDifficulty: Double? {
        let ratings = runSessions?.compactMap { $0.difficultyRating } ?? []
        guard !ratings.isEmpty else { return nil }
        return Double(ratings.reduce(0, +)) / Double(ratings.count)
    }

    var recentPainReports: Int {
        let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        return runSessions?.filter {
            $0.painReported && $0.completedDate > twoWeeksAgo
        }.count ?? 0
    }

    var activeTasks: [CoachTask] {
        tasks?.filter { !$0.isCompleted } ?? []
    }

    var overdueTasks: [CoachTask] {
        tasks?.filter { $0.isOverdue } ?? []
    }

    var nextScheduledRun: ScheduledRun? {
        runningSchedule?.nextRun
    }

    var upcomingMilestone: Milestone? {
        milestones?.filter { !$0.isCompleted }
            .sorted { ($0.targetDate ?? Date.distantFuture) < ($1.targetDate ?? Date.distantFuture) }
            .first
    }
}
