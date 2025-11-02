import Foundation
import SwiftData

@Model
final class RunSession {
    @Attribute(.unique) var id: UUID
    var scheduledRunId: UUID?
    var goalId: UUID
    var completedDate: Date
    var actualDistance: Double? // kilometers
    var duration: Int? // minutes
    var difficultyRating: Int? // 1-10 scale
    var painReported: Bool
    var painLocation: String?
    var painDescription: String?
    var energyLevel: String? // "low", "medium", "high"
    var overallFeeling: String? // "great", "good", "okay", "hard", "terrible"
    var notes: String?
    var weatherConditions: String?
    var conversationSessionId: UUID?

    init(
        id: UUID = UUID(),
        scheduledRunId: UUID? = nil,
        goalId: UUID,
        completedDate: Date = Date(),
        actualDistance: Double? = nil,
        duration: Int? = nil,
        difficultyRating: Int? = nil,
        painReported: Bool = false,
        painLocation: String? = nil,
        painDescription: String? = nil,
        energyLevel: String? = nil,
        overallFeeling: String? = nil,
        notes: String? = nil,
        weatherConditions: String? = nil,
        conversationSessionId: UUID? = nil
    ) {
        self.id = id
        self.scheduledRunId = scheduledRunId
        self.goalId = goalId
        self.completedDate = completedDate
        self.actualDistance = actualDistance
        self.duration = duration
        self.difficultyRating = difficultyRating
        self.painReported = painReported
        self.painLocation = painLocation
        self.painDescription = painDescription
        self.energyLevel = energyLevel
        self.overallFeeling = overallFeeling
        self.notes = notes
        self.weatherConditions = weatherConditions
        self.conversationSessionId = conversationSessionId
    }

    // Computed properties
    var averagePace: Double? {
        guard let distance = actualDistance,
              let duration = duration,
              duration > 0 else { return nil }
        return Double(duration) / distance // minutes per km
    }

    var wasTooEasy: Bool {
        guard let rating = difficultyRating else { return false }
        return rating <= 3
    }

    var wasTooHard: Bool {
        guard let rating = difficultyRating else { return false }
        return rating >= 8
    }

    var wasJustRight: Bool {
        guard let rating = difficultyRating else { return false }
        return rating >= 5 && rating <= 7
    }
}
