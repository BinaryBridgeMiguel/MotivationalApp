import Foundation
import SwiftData

@Model
final class ConversationSession {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date?
    var transcript: String?

    @Relationship(deleteRule: .nullify, inverse: \User.conversationSessions) var user: User?

    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        transcript: String? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.transcript = transcript
    }
}
