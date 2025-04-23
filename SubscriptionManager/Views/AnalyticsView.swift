import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var dataController: DataController
    
    var activeSubscriptions: [Subscription] {
        dataController.getActiveSubscriptions()
    }
    
    var subscriptionsByCategory: [SubscriptionCategory: [Subscription]] {
        dataController.getSubscriptionsByCategory()
    }
    
    var totalMonthlySpending: Double {
        dataController.getTotalMonthlySpending()
    }
    
    var yearlySpending: Double {
        totalMonthlySpending * 12
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary cards
                HStack(spacing: 15) {
                    SummaryCard(
                        title: "Monthly",
                        value: "$\(String(format: "%.2f", totalMonthlySpending))",
                        icon: "dollarsign.circle.fill",
                        color: .green
                    )
                    
                    SummaryCard(
                        title: "Yearly",
                        value: "$\(String(format: "%.2f", yearlySpending))",
                        icon: "calendar.circle.fill",
                        color: .blue
                    )
                }
                .padding(.horizontal)
                
                // Subscriptions by category
                VStack(alignment: .leading, spacing: 10) {
                    Text("Spending by Category")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if activeSubscriptions.isEmpty {
                        Text("No active subscriptions")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else {
                        Chart {
                            ForEach(SubscriptionCategory.allCases) { category in
                                let subscriptions = subscriptionsByCategory[category] ?? []
                                let total = subscriptions.reduce(0) { $0 + $1.monthlyPrice }
                                
                                if total > 0 {
                                    SectorMark(
                                        angle: .value("Spending", total),
                                        innerRadius: .ratio(0.6),
                                        angularInset: 1.5
                                    )
                                    .foregroundStyle(Color(category.color))
                                    .cornerRadius(5)
                                    .annotation(position: .overlay) {
                                        Text("\(Int(total / totalMonthlySpending * 100))%")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        
                        // Legend
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(SubscriptionCategory.allCases) { category in
                                let subscriptions = subscriptionsByCategory[category] ?? []
                                let total = subscriptions.reduce(0) { $0 + $1.monthlyPrice }
                                
                                if total > 0 {
                                    HStack(spacing: 10) {
                                        Circle()
                                            .fill(Color(category.color))
                                            .frame(width: 12, height: 12)
                                        
                                        Text(category.rawValue)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        
                                        Text("$\(total, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Monthly breakdown
                VStack(alignment: .leading, spacing: 10) {
                    Text("Monthly Breakdown")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if activeSubscriptions.isEmpty {
                        Text("No active subscriptions")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else {
                        VStack(spacing: 15) {
                            ForEach(activeSubscriptions.sorted(by: { $0.monthlyPrice > $1.monthlyPrice })) { subscription in
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(subscription.categoryEnum.color).opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: subscription.categoryEnum.icon)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(subscription.categoryEnum.color))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(subscription.wrappedName)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text(subscription.billingCycleEnum.rawValue)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("$\(subscription.monthlyPrice, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Text("\(Int(subscription.monthlyPrice / totalMonthlySpending * 100))%")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal)
                                
                                if subscription != activeSubscriptions.sorted(by: { $0.monthlyPrice > $1.monthlyPrice }).last {
                                    Divider()
                                        .padding(.leading, 60)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
