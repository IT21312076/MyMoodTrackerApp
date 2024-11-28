import SwiftUI

@main
struct MyMoodTrackerApp: App {
    @State private var isLoggedIn = false // Manage login state
    @State private var showMainPage = true // Flag to show the initial Main Page

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if showMainPage {
                // First, show the Main Page
                MainPageView(showMainPage: $showMainPage)
                    .environment(\.managedObjectContext, persistenceController.viewContext)
            } else if isLoggedIn {
                // After login, navigate to the Mood Entry Page
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.viewContext)
            } else {
                // Show the login page if not logged in
                LoginPageView(isLoggedIn: $isLoggedIn)
                    .environment(\.managedObjectContext, persistenceController.viewContext)
            }
        }
    }
}
