import XCTest
@testable import SubscriptionManager

final class SubscriptionModelTests: XCTestCase {
    var dataController: DataController!
    var testSubscription: Subscription!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        
        // Create a test subscription
        testSubscription = Subscription(context: dataController.container.viewContext)
        testSubscription.id = UUID()
        testSubscription.name = "Test Subscription"
        testSubscription.price = 9.99
        testSubscription.category = SubscriptionCategory.entertainment.rawValue
        testSubscription.billingCycle = BillingCycle.monthly.rawValue
        testSubscription.startDate = Date()
        testSubscription.notes = "Test notes"
        
        try dataController.container.viewContext.save()
    }
    
    override func tearDownWithError() throws {
        dataController = nil
        testSubscription = nil
    }
    
    func testSubscriptionCreation() throws {
        XCTAssertNotNil(testSubscription)
        XCTAssertEqual(testSubscription.wrappedName, "Test Subscription")
        XCTAssertEqual(testSubscription.price, 9.99)
        XCTAssertEqual(testSubscription.categoryEnum, .entertainment)
        XCTAssertEqual(testSubscription.billingCycleEnum, .monthly)
    }
    
    func testMonthlyPrice() throws {
        // Monthly subscription
        testSubscription.billingCycle = BillingCycle.monthly.rawValue
        XCTAssertEqual(testSubscription.monthlyPrice, 9.99)
        
        // Quarterly subscription
        testSubscription.billingCycle = BillingCycle.quarterly.rawValue
        XCTAssertEqual(testSubscription.monthlyPrice, 9.99 / 3, accuracy: 0.01)
        
        // Annual subscription
        testSubscription.billingCycle = BillingCycle.annually.rawValue
        XCTAssertEqual(testSubscription.monthlyPrice, 9.99 / 12, accuracy: 0.01)
    }
    
    func testNextBillingDate() throws {
        // Set start date to 1 month ago
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
        testSubscription.startDate = oneMonthAgo
        testSubscription.billingCycle = BillingCycle.monthly.rawValue
        
        // Next billing date should be today (approximately)
        let nextBillingDate = testSubscription.nextBillingDate
        let daysBetween = calendar.dateComponents([.day], from: Date(), to: nextBillingDate).day ?? 0
        
        // Allow for small differences due to exact time of day
        XCTAssertTrue(abs(daysBetween) <= 1)
    }
    
    func testIsActive() throws {
        // Subscription with no cancel date should be active
        XCTAssertNil(testSubscription.cancelDate)
        XCTAssertTrue(testSubscription.isActive)
        
        // Subscription with future cancel date should be active
        let futureDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        testSubscription.cancelDate = futureDate
        XCTAssertTrue(testSubscription.isActive)
        
        // Subscription with past cancel date should not be active
        let pastDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        testSubscription.cancelDate = pastDate
        XCTAssertFalse(testSubscription.isActive)
    }
}
