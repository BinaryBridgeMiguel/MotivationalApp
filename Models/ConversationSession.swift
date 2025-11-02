import Foundation
import SwiftData

@Model
final class ConversationSession {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date?
    var transcript: String?
    var conversationType: String? // "pre_run", "post_run", "planning", "motivation", "general"
    var relatedRunId: UUID?
    var sentiment: String? // "positive", "neutral", "struggling", "motivated"
    var keyTopics: [String]? // Topics discussed
    var tasksCreated: [UUID]? // IDs of tasks created during conversation

    @Relationship(deleteRule: .nullify, inverse: \User.conversationSessions) var user: User?

    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        transcript: String? = nil,
        conversationType: String? = nil,
        relatedRunId: UUID? = nil,
        sentiment: String? = nil,
        keyTopics: [String]? = nil,
        tasksCreated: [UUID]? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.transcript = transcript
        self.conversationType = conversationType
        self.relatedRunId = relatedRunId
        self.sentiment = sentiment
        self.keyTopics = keyTopics
        self.tasksCreated = tasksCreated
    }

    // Computed properties
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }

    var durationMinutes: Int? {
        guard let duration = duration else { return nil }
        return Int(duration / 60)
    }

    var isPreRunCheckIn: Bool {
        conversationType == "pre_run"
    }

    var isPostRunCheckIn: Bool {
        conversationType == "post_run"
    }
}
