import XCTest

final class SubscriptionManagerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    func testAddSubscription() throws {
        // Navigate to subscriptions tab
        app.tabBars.buttons["Subscriptions"].tap()
        
        // Tap the add button
        app.navigationBars.buttons["Add"].tap()
        
        // Fill in subscription details
        let nameField = app.textFields["subscriptionNameField"]
        XCTAssertTrue(nameField.exists)
        nameField.tap()
        nameField.typeText("Netflix")
        
        let priceField = app.textFields["subscriptionPriceField"]
        XCTAssertTrue(priceField.exists)
        priceField.tap()
        priceField.typeText("14.99")
        
        // Select category
        app.buttons["Category"].tap()
        app.buttons["Entertainment"].tap()
        
        // Select billing cycle
        app.buttons["Billing Cycle"].tap()
        app.buttons["Monthly"].tap()
        
        // Save the subscription
        app.buttons["Save Subscription"].tap()
        
        // Verify the subscription was added
        XCTAssertTrue(app.staticTexts["Netflix"].exists)
        XCTAssertTrue(app.staticTexts["$14.99"].exists)
    }
    
    func testDeleteSubscription() throws {
        // First add a subscription
        try testAddSubscription()
        
        // Swipe to delete
        app.staticTexts["Netflix"].swipeLeft()
        app.buttons["Delete"].tap()
        
        // Verify it's gone
        XCTAssertFalse(app.staticTexts["Netflix"].exists)
    }
    
    func testFilterSubscriptions() throws {
        // Add multiple subscriptions of different categories
        // (This would be a more complex setup)
        
        // Test filter functionality
        app.scrollViews.otherElements.buttons["Entertainment"].tap()
        
        // Verify only entertainment subscriptions are shown
        // (Would need specific assertions based on test data)
        
        // Clear filter
        app.scrollViews.otherElements.buttons["All"].tap()
    }
}
