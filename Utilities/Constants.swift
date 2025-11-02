import Foundation
import SwiftUI

enum Constants {
    // MARK: - ElevenLabs Configuration
    enum ElevenLabs {
        static let apiKey = "YOUR_ELEVENLABS_API_KEY" // TODO: Replace with your actual API key
        static let agentId = "YOUR_AGENT_ID" // TODO: Replace with your actual Agent ID
    }

    // MARK: - App Configuration
    enum App {
        static let name = "Coach"
        static let defaultCheckInTime = DateComponents(hour: 20, minute: 0) // 8 PM daily check-in
    }

    // MARK: - UI Constants
    enum UI {
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 56
        static let spacing: CGFloat = 20
        static let horizontalPadding: CGFloat = 24

        enum Colors {
            static let primary = Color.blue
            static let secondary = Color.gray
            static let success = Color.green
            static let background = Color(.systemBackground)
            static let secondaryBackground = Color(.secondarySystemBackground)
        }
    }

    // MARK: - Notification Identifiers
    enum Notifications {
        static let dailyCheckIn = "daily-check-in"
        static let categoryIdentifier = "COACH_NOTIFICATION"
    }
}
