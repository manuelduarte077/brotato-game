import CoreData
import SwiftUI

class DataController: ObservableObject {
    static let shared = DataController()
    
    static var preview: DataController = {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create 10 sample subscriptions
        for i in 0..<10 {
            let subscription = Subscription(context: viewContext)
            subscription.id = UUID()
            subscription.name = "Sample Subscription \(i + 1)"
            subscription.price = Double((i + 1) * 5)
            subscription.category = SubscriptionCategory.allCases[i % SubscriptionCategory.allCases.count].rawValue
            subscription.billingCycle = BillingCycle.allCases[i % BillingCycle.allCases.count].rawValue
            subscription.startDate = Date().addingTimeInterval(-Double(i * 30) * 86400)
            subscription.notes = "This is a sample subscription for testing purposes."
            
            if i % 3 == 0 {
                subscription.cancelDate = Date().addingTimeInterval(Double(i * 15) * 86400)
            }
        }
        
        try? viewContext.save()
        return controller
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SubscriptionModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
            // Merge policy
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        save()
    }
    
    func getAllSubscriptions() -> [Subscription] {
        let request: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Subscription.name, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching subscriptions: \(error)")
            return []
        }
    }
    
    func getActiveSubscriptions() -> [Subscription] {
        let request: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        request.predicate = NSPredicate(format: "cancelDate == nil OR cancelDate > %@", Date() as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Subscription.name, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching active subscriptions: \(error)")
            return []
        }
    }
    
    func getSubscriptionsByCategory() -> [SubscriptionCategory: [Subscription]] {
        let subscriptions = getActiveSubscriptions()
        var result = [SubscriptionCategory: [Subscription]]()
        
        for category in SubscriptionCategory.allCases {
            result[category] = subscriptions.filter { $0.categoryEnum == category }
        }
        
        return result
    }
    
    func getTotalMonthlySpending() -> Double {
        let activeSubscriptions = getActiveSubscriptions()
        return activeSubscriptions.reduce(0) { $0 + $1.monthlyPrice }
    }
    
    func getUpcomingPayments(within days: Int = 30) -> [Subscription] {
        let activeSubscriptions = getActiveSubscriptions()
        let targetDate = Date().addingTimeInterval(Double(days) * 86400)
        
        return activeSubscriptions.filter { subscription in
            let nextBillingDate = subscription.nextBillingDate
            return nextBillingDate <= targetDate
        }
    }
}