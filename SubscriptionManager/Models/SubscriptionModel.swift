
import Foundation
import CoreData
import SwiftUI

enum SubscriptionCategory: String, CaseIterable, Identifiable {
    case entertainment = "Entertainment"
    case fitness = "Fitness"
    case productivity = "Productivity"
    case utilities = "Utilities"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .entertainment: return "tv"
        case .fitness: return "figure.walk"
        case .productivity: return "briefcase"
        case .utilities: return "bolt"
        case .other: return "square"
        }
    }
    
    var color: String {
        switch self {
            case .entertainment: return "colorEntertainment"
            case .fitness: return "colorFitness"
            case .productivity: return "colorProductivity"
            case .utilities: return "colorUtilities"
            case .other: return "colorOther"
        }
    }
}

enum BillingCycle: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case biannually = "Biannually"
    case annually = "Annually"
    
    var id: String { self.rawValue }
    
    var monthsInterval: Int {
        switch self {
        case .monthly: return 1
        case .quarterly: return 3
        case .biannually: return 6
        case .annually: return 12
        }
    }
    
    var daysInterval: Int {
        return monthsInterval * 30
    }
}

extension Subscription {
    var categoryEnum: SubscriptionCategory {
        get {
            return SubscriptionCategory(rawValue: category ?? "Other") ?? .other
        }
        set {
            category = newValue.rawValue
        }
    }
    
    var billingCycleEnum: BillingCycle {
        get {
            return BillingCycle(rawValue: billingCycle ?? "Monthly") ?? .monthly
        }
        set {
            billingCycle = newValue.rawValue
        }
    }
    
    var wrappedName: String {
        name ?? "Unknown Subscription"
    }
    
    var wrappedNotes: String {
        notes ?? ""
    }
    
    var monthlyPrice: Double {
        let price = self.price
        
        switch billingCycleEnum {
        case .monthly:
            return price
        case .quarterly:
            return price / 3
        case .biannually:
            return price / 6
        case .annually:
            return price / 12
        }
    }
    
    var nextBillingDate: Date {
        guard let startDate = startDate else {
            return Date()
        }
        
        let calendar = Calendar.current
        let monthsToAdd = billingCycleEnum.monthsInterval
        
        // Calculate how many billing cycles have passed
        let components = calendar.dateComponents([.month], from: startDate, to: Date())
        guard let monthsPassed = components.month else { return Date() }
        
        let cyclesPassed = monthsPassed / monthsToAdd
        
        // Calculate the next billing date
        var nextDateComponents = DateComponents()
        nextDateComponents.month = monthsToAdd * (cyclesPassed + 1)
        
        return calendar.date(byAdding: nextDateComponents, to: startDate) ?? Date()
    }
    
    var isActive: Bool {
        return cancelDate == nil || cancelDate! > Date()
    }
}
