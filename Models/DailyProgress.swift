import Foundation
import SwiftData

@Model
final class DailyProgress {
    @Attribute(.unique) var id: UUID
    var date: Date
    var completed: Bool
    var notes: String?

    @Relationship(deleteRule: .nullify, inverse: \Goal.dailyProgress) var goal: Goal?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        completed: Bool = false,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.completed = completed
        self.notes = notes
    }
}
