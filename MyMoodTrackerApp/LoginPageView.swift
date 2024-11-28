import SwiftUI
import CoreData

struct LoginPageView: View {
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginErrorMessage: String?

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if let errorMessage = loginErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Login") {
                    login()
                }
                .padding()

                NavigationLink("Don't have an account? Sign Up", destination: SignUpPageView(isLoggedIn: $isLoggedIn))
                    .padding()
            }
            .padding()
            .navigationTitle("Login")
        }
    }

    private func login() {
        // Fetch the user from Core Data
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first, user.password == password {
                // Successful login
                loginErrorMessage = nil
                isLoggedIn = true  // User is logged in, navigate to Mood Entry Page
            } else {
                // Invalid login
                loginErrorMessage = "Invalid credentials. Please try again."
            }
        } catch {
            loginErrorMessage = "Error checking user credentials."
        }
    }
}
