import SwiftUI

struct SubscriptionListView: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingAddSubscription = false
    @State private var searchText = ""
    @State private var filterCategory: SubscriptionCategory?
    
    var filteredSubscriptions: [Subscription] {
        let subscriptions = dataController.getActiveSubscriptions()
        
        if searchText.isEmpty && filterCategory == nil {
            return subscriptions
        }
        
        return subscriptions.filter { subscription in
            let matchesSearch = searchText.isEmpty || 
                subscription.wrappedName.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = filterCategory == nil || 
                subscription.categoryEnum == filterCategory
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        VStack {
            // Filter bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FilterChip(title: "All", isSelected: filterCategory == nil) {
                        filterCategory = nil
                    }
                    
                    ForEach(SubscriptionCategory.allCases) { category in
                        FilterChip(
                            title: category.rawValue,
                            icon: category.icon,
                            color: Color(category.color),
                            isSelected: filterCategory == category
                        ) {
                            filterCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            if filteredSubscriptions.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No subscriptions found")
                        .font(.headline)
                    
                    Text("Add your first subscription to start tracking")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        showingAddSubscription = true
                    }) {
                        Text("Add Subscription")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    Section(header: Text("Upcoming payments")) {
                        ForEach(dataController.getUpcomingPayments(within: 7)) { subscription in
                            SubscriptionRow(subscription: subscription)
                                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                        }
                    }
                    
                    Section(header: Text("All subscriptions")) {
                        ForEach(filteredSubscriptions) { subscription in
                            NavigationLink(destination: SubscriptionDetailView(subscription: subscription)) {
                                SubscriptionRow(subscription: subscription)
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                        }
                        .onDelete(perform: deleteSubscription)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .searchable(text: $searchText, prompt: "Search subscriptions")
        .navigationBarItems(
            trailing: Button(action: {
                showingAddSubscription = true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showingAddSubscription) {
            NavigationView {
                AddSubscriptionView()
                    .navigationTitle("New Subscription")
                    .navigationBarItems(
                        trailing: Button("Cancel") {
                            showingAddSubscription = false
                        }
                    )
            }
        }
    }
    
    func deleteSubscription(at offsets: IndexSet) {
        for index in offsets {
            let subscription = filteredSubscriptions[index]
            dataController.delete(subscription)
        }
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    var color: Color = .indigo
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? color : .primary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct SubscriptionRow: View {
    let subscription: Subscription
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(subscription.categoryEnum.color).opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: subscription.categoryEnum.icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(subscription.categoryEnum.color))
            }
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.wrappedName)
                    .font(.headline)
                
                HStack {
                    Text(subscription.categoryEnum.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(subscription.billingCycleEnum.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("Next payment: \(subscription.nextBillingDate, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Price
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(subscription.price, specifier: "%.2f")")
                    .font(.headline)
                
                Text("$\(subscription.monthlyPrice, specifier: "%.2f")/mo")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
