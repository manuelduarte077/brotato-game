import SwiftUI

struct SubscriptionDetailView: View {
    @ObservedObject var subscription: Subscription
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var notificationManager: NotificationManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingCancelAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color(subscription.categoryEnum.color).opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: subscription.categoryEnum.icon)
                            .font(.system(size: 30))
                            .foregroundColor(Color(subscription.categoryEnum.color))
                    }
                    
                    Text(subscription.wrappedName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(subscription.categoryEnum.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Price info
                HStack(spacing: 30) {
                    VStack {
                        Text("$\(subscription.price, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(subscription.billingCycleEnum.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .frame(height: 40)
                    
                    VStack {
                        Text("$\(subscription.monthlyPrice, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Monthly")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Dates
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 30)
                            .foregroundColor(.indigo)
                        
                        Text("Started on")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(subscription.startDate ?? Date(), formatter: dateFormatter)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "creditcard")
                            .frame(width: 30)
                            .foregroundColor(.indigo)
                        
                        Text("Next payment")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(subscription.nextBillingDate, formatter: dateFormatter)
                            .fontWeight(.medium)
                    }
                    
                    if let cancelDate = subscription.cancelDate {
                        Divider()
                        
                        HStack {
                            Image(systemName: "xmark.circle")
                                .frame(width: 30)
                                .foregroundColor(.red)
                            
                            Text("Cancels on")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(cancelDate, formatter: dateFormatter)
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Notes
                if !subscription.wrappedNotes.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes")
                            .font(.headline)
                        
                        Text(subscription.wrappedNotes)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                
                // Action buttons
                VStack(spacing: 15) {
                    Button(action: {
                        showingEditSheet = true
                    }) {
                        Label("Edit Subscription", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    if subscription.cancelDate == nil {
                        Button(action: {
                            showingCancelAlert = true
                        }) {
                            Label("Cancel Subscription", systemImage: "xmark.circle")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Label("Delete Subscription", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarItems(trailing: Button(action: {
            showingEditSheet = true
        }) {
            Image(systemName: "pencil")
        })
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                EditSubscriptionView(subscription: subscription)
                    .navigationTitle("Edit Subscription")
                    .navigationBarItems(trailing: Button("Cancel") {
                        showingEditSheet = false
                    })
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Subscription"),
                message: Text("Are you sure you want to delete this subscription? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteSubscription()
                },
                secondaryButton: .cancel()
            )
        }
        .alert(isPresented: $showingCancelAlert) {
            Alert(
                title: Text("Cancel Subscription"),
                message: Text("Do you want to mark this subscription as canceled?"),
                primaryButton: .destructive(Text("Cancel Subscription")) {
                    cancelSubscription()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    func deleteSubscription() {
        dataController.delete(subscription)
        notificationManager.removeNotifications(for: subscription.id?.uuidString ?? "")
        presentationMode.wrappedValue.dismiss()
    }
    
    func cancelSubscription() {
        subscription.cancelDate = Date()
        dataController.save()
        notificationManager.removeNotifications(for: subscription.id?.uuidString ?? "")
    }
}