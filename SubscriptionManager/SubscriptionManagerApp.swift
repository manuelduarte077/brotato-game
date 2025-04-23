import SwiftUI
import CoreData

@main
struct SubscriptionManagerApp: App {
    @StateObject private var dataController = DataController.shared
    @StateObject private var notificationManager = NotificationManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(notificationManager)
                .preferredColorScheme(.light)
                .onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    notificationManager.requestAuthorization()
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                UIApplication.shared.applicationIconBadgeNumber = 0
            } else if newPhase == .background {
                dataController.save()
            }
        }
    }
}
