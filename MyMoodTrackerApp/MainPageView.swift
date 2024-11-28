import SwiftUI

struct MainPageView: View {
    @Binding var showMainPage: Bool // This binds to the main app view to switch to login page

    var body: some View {
        VStack {
            Text("Welcome to My Mood Tracker")
                .font(.largeTitle)
                .padding()

            Text("Track your mood and improve your mental health")
                .padding()

            Button("Get Started") {
                // After tapping "Get Started", show the Login Page
                showMainPage = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Main Page")
    }
}
