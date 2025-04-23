import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func schedulePaymentReminder(for subscription: Subscription, daysInAdvance: Int) {
        guard let id = subscription.id?.uuidString else { return }
        
        // Remove any existing notifications for this subscription
        removeNotifications(for: id)
        
        // Calculate next billing date
        let nextBillingDate = subscription.nextBillingDate
        
        // Calculate reminder date (days before billing)
        let reminderDate = Calendar.current.date(byAdding: .day, value: -daysInAdvance, to: nextBillingDate)
        
        guard let reminderDate = reminderDate else { return }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Payment"
        content.body = "\(subscription.wrappedName) payment of $\(String(format: "%.2f", subscription.price)) due in \(daysInAdvance) days"
        content.sound = .default
        content.badge = 1
        
        // Create date components for the reminder
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        // Add request to notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotifications(for subscriptionId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [subscriptionId])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [subscriptionId])
    }
}