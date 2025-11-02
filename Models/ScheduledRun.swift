import Foundation
import SwiftData

@Model
final class ScheduledRun {
    @Attribute(.unique) var id: UUID
    var scheduleId: UUID
    var scheduledDateTime: Date
    var distance: Double // kilometers
    var runType: String // "easy", "tempo", "long", "recovery", "interval"
    var targetPace: String? // "easy pace", "tempo pace", etc.
    var status: String // "scheduled", "completed", "missed", "rescheduled", "skipped"
    var preRunCallScheduled: Bool
    var preRunCallTime: Date?
    var preRunCallCompleted: Bool
    var notes: String?
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .nullify) var runSession: RunSession?

    init(
        id: UUID = UUID(),
        scheduleId: UUID,
        scheduledDateTime: Date,
        distance: Double,
        runType: String = "easy",
        targetPace: String? = nil,
        status: String = "scheduled",
        preRunCallScheduled: Bool = false,
        preRunCallTime: Date? = nil,
        preRunCallCompleted: Bool = false,
        notes: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.scheduleId = scheduleId
        self.scheduledDateTime = scheduledDateTime
        self.distance = distance
        self.runType = runType
        self.targetPace = targetPace
        self.status = status
        self.preRunCallScheduled = preRunCallScheduled
        self.preRunCallTime = preRunCallTime
        self.preRunCallCompleted = preRunCallCompleted
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // Computed properties
    var isToday: Bool {
        Calendar.current.isDateInToday(scheduledDateTime)
    }

    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(scheduledDateTime)
    }

    var isPast: Bool {
        scheduledDateTime < Date()
    }

    var timeUntilRun: TimeInterval {
        scheduledDateTime.timeIntervalSinceNow
    }

    var formattedDistance: String {
        String(format: "%.1f km", distance)
    }

    var isCompleted: Bool {
        status == "completed"
    }

    var isMissed: Bool {
        status == "missed"
    }
}
