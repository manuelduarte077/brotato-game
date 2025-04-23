import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SubscriptionListView()
                    .navigationTitle("Subscriptions")
            }
            .tabItem {
                Label("Subscriptions", systemImage: "list.bullet")
            }
            .tag(0)
            
            NavigationView {
                AnalyticsView()
                    .navigationTitle("Analytics")
            }
            .tabItem {
                Label("Analytics", systemImage: "chart.pie")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .accentColor(.indigo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController.preview)
    }
}
