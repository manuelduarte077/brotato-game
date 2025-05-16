import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var notificationsEnabled = true
    @State private var defaultReminderDays = 3
    @State private var showExportSheet = false
    @State private var showAboutSheet = false
    
    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { newValue in
                        if newValue {
                            notificationManager.requestAuthorization()
                        }
                    }
                
                if notificationsEnabled {
                    Stepper("Remind \(defaultReminderDays) days before payment", value: $defaultReminderDays, in: 1...14)
                }
            }
            
            Section(header: Text("Data")) {
                Button(action: {
                    showExportSheet = true
                }) {
                    Label("Export Subscriptions", systemImage: "square.and.arrow.up")
                }
                
                Button(action: {
                    // Import functionality would go here
                }) {
                    Label("Import Subscriptions", systemImage: "square.and.arrow.down")
                }
            }
            
            Section(header: Text("About")) {
                Button(action: {
                    showAboutSheet = true
                }) {
                    Label("About Subscription Manager", systemImage: "info.circle")
                }
                
                Link(destination: URL(string: "https://example.com/privacy")!) {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                
                Link(destination: URL(string: "https://example.com/terms")!) {
                    Label("Terms of Service", systemImage: "doc.text")
                }
            }
            
            Section(header: Text("App Version")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $showAboutSheet) {
            AboutView()
        }
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "creditcard.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.indigo)
                
                Text("Subscription Manager")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Version 1.0.0")
                    .foregroundColor(.secondary)
                
                Divider()
                    .padding(.vertical)
                
                Text("Subscription Manager helps you track and manage all your recurring subscriptions in one place.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("© 2023 Your Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the sheet
            })
        }
    }
}
