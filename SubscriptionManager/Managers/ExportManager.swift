import Foundation
import CoreData
import UIKit

class ExportManager {
    static let shared = ExportManager()
    
    func exportSubscriptions(from dataController: DataController) -> URL? {
        let subscriptions = dataController.getAllSubscriptions()
        
        var exportData: [[String: Any]] = []
        
        for subscription in subscriptions {
            var subscriptionData: [String: Any] = [
                "name": subscription.wrappedName,
                "price": subscription.price,
                "category": subscription.category ?? "",
                "billingCycle": subscription.billingCycle ?? "",
                "notes": subscription.wrappedNotes
            ]
            
            if let startDate = subscription.startDate {
                subscriptionData["startDate"] = ISO8601DateFormatter().string(from: startDate)
            }
            
            if let cancelDate = subscription.cancelDate {
                subscriptionData["cancelDate"] = ISO8601DateFormatter().string(from: cancelDate)
            }
            
            exportData.append(subscriptionData)
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
            
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let exportURL = documentsDirectory.appendingPathComponent("subscriptions_export.json")
            
            try jsonData.write(to: exportURL)
            return exportURL
        } catch {
            print("Error exporting subscriptions: \(error)")
            return nil
        }
    }
    
    func importSubscriptions(from url: URL, into dataController: DataController) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            
            guard let subscriptionsData = jsonArray else {
                return false
            }
            
            let context = dataController.container.viewContext
            let dateFormatter = ISO8601DateFormatter()
            
            for subscriptionData in subscriptionsData {
                let subscription = Subscription(context: context)
                subscription.id = UUID()
                subscription.name = subscriptionData["name"] as? String
                subscription.price = subscriptionData["price"] as? Double ?? 0
                subscription.category = subscriptionData["category"] as? String
                subscription.billingCycle = subscriptionData["billingCycle"] as? String
                subscription.notes = subscriptionData["notes"] as? String
                
                if let startDateString = subscriptionData["startDate"] as? String {
                    subscription.startDate = dateFormatter.date(from: startDateString)
                }
                
                if let cancelDateString = subscriptionData["cancelDate"] as? String {
                    subscription.cancelDate = dateFormatter.date(from: cancelDateString)
                }
            }
            
            dataController.save()
            return true
        } catch {
            print("Error importing subscriptions: \(error)")
            return false
        }
    }
    
    func shareExport(url: URL, from viewController: UIViewController) {
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        viewController.present(activityViewController, animated: true)
    }
}
