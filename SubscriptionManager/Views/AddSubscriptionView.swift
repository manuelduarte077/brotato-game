import SwiftUI

struct AddSubscriptionView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var name = ""
    @State private var price = ""
    @State private var selectedCategory = SubscriptionCategory.entertainment
    @State private var selectedBillingCycle = BillingCycle.monthly
    @State private var startDate = Date()
    @State private var notes = ""
    @State private var remindMe = true
    @State private var reminderDays = 3
    
    var body: some View {
        Form {
            Section(header: Text("Subscription Details")) {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("subscriptionNameField")
                
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("subscriptionPriceField")
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(SubscriptionCategory.allCases) { category in
                        Label {
                            Text(category.rawValue)
                        } icon: {
                            Image(systemName: category.icon)
                                .foregroundColor(Color(category.color))
                        }
                        .tag(category)
                    }
                }
                
                Picker("Billing Cycle", selection: $selectedBillingCycle) {
                    ForEach(BillingCycle.allCases) { cycle in
                        Text(cycle.rawValue).tag(cycle)
                    }
                }
                
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Remind me before payment", isOn: $remindMe)
                
                if remindMe {
                    Stepper("Remind \(reminderDays) days before", value: $reminderDays, in: 1...14)
                }
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
            
            Section {
                Button(action: saveSubscription) {
                    Text("Save Subscription")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.mainColor)
                .disabled(name.isEmpty || price.isEmpty)
            }
        }
    }
    
    func saveSubscription() {
        guard let priceValue = Double(price) else { return }
        
        let subscription = Subscription(context: moc)
        subscription.id = UUID()
        subscription.name = name
        subscription.price = priceValue
        subscription.category = selectedCategory.rawValue
        subscription.billingCycle = selectedBillingCycle.rawValue
        subscription.startDate = startDate
        subscription.notes = notes
        
        dataController.save()
        
        if remindMe {
            notificationManager.schedulePaymentReminder(
                for: subscription,
                daysInAdvance: reminderDays
            )
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
