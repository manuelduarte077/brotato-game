import SwiftUI

struct EditSubscriptionView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var notificationManager: NotificationManager
    @ObservedObject var subscription: Subscription
    
    @State private var name: String
    @State private var price: String
    @State private var selectedCategory: SubscriptionCategory
    @State private var selectedBillingCycle: BillingCycle
    @State private var startDate: Date
    @State private var notes: String
    @State private var remindMe: Bool
    @State private var reminderDays: Int
    
    init(subscription: Subscription) {
        self.subscription = subscription
        
        // Initialize state variables with subscription values
        _name = State(initialValue: subscription.wrappedName)
        _price = State(initialValue: String(format: "%.2f", subscription.price))
        _selectedCategory = State(initialValue: subscription.categoryEnum)
        _selectedBillingCycle = State(initialValue: subscription.billingCycleEnum)
        _startDate = State(initialValue: subscription.startDate ?? Date())
        _notes = State(initialValue: subscription.wrappedNotes)
        _remindMe = State(initialValue: true)
        _reminderDays = State(initialValue: 3)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Subscription Details")) {
                TextField("Name", text: $name)
                
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                
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
                Button(action: updateSubscription) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.indigo)
                .disabled(name.isEmpty || price.isEmpty)
            }
        }
    }
    
    func updateSubscription() {
        guard let priceValue = Double(price) else { return }
        
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
        } else {
            notificationManager.removeNotifications(for: subscription.id?.uuidString ?? "")
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}