import Foundation
import UserNotifications
import Combine

class NotificationService: ObservableObject {
    @Published var isAuthorized = false

    init() {
        checkAuthorization()
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }

    private func checkAuthorization() {
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            isAuthorized = settings.authorizationStatus == .authorized
        }
    }

    // MARK: - Daily Check-in Notification

    func scheduleDailyCheckIn() async {
        guard isAuthorized else {
            print("Notifications not authorized")
            return
        }

        // Remove existing daily check-in notifications
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [Constants.Notifications.dailyCheckIn])

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "How did today go?"
        content.body = "Your coach wants to check in on your progress."
        content.sound = .default
        content.categoryIdentifier = Constants.Notifications.categoryIdentifier

        // Create trigger for daily check-in
        var dateComponents = Constants.App.defaultCheckInTime
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create request
        let request = UNNotificationRequest(
            identifier: Constants.Notifications.dailyCheckIn,
            content: content,
            trigger: trigger
        )

        // Schedule notification
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("Daily check-in notification scheduled")
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }

    func cancelDailyCheckIn() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [Constants.Notifications.dailyCheckIn])
    }

    // MARK: - Notification Actions

    func setupNotificationCategories() {
        let checkInAction = UNNotificationAction(
            identifier: "CHECK_IN",
            title: "Talk to Coach",
            options: .foreground
        )

        let skipAction = UNNotificationAction(
            identifier: "SKIP",
            title: "Skip",
            options: []
        )

        let category = UNNotificationCategory(
            identifier: Constants.Notifications.categoryIdentifier,
            actions: [checkInAction, skipAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}
