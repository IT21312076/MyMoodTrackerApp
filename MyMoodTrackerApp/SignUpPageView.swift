import SwiftUI
import CoreData

struct SignUpPageView: View {
    @Binding var isLoggedIn: Bool

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var signUpErrorMessage: String?

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if let errorMessage = signUpErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button("Sign Up") {
                    signUp()
                }
                .padding()

                NavigationLink("Already have an account? Login", destination: LoginPageView(isLoggedIn: $isLoggedIn))
                    .padding()
            }
            .padding()
            .navigationTitle("Sign Up")
        }
    }

    private func signUp() {
        guard !username.isEmpty, !password.isEmpty else {
            signUpErrorMessage = "Username and password cannot be empty."
            return
        }

        if password != confirmPassword {
            signUpErrorMessage = "Passwords do not match."
            return
        }

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let existingUsers = try viewContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                signUpErrorMessage = "Username already exists."
                return
            }
        } catch {
            signUpErrorMessage = "Error checking existing users."
            return
        }

        let newUser = User(context: viewContext)
        newUser.username = username
        newUser.password = password

        do {
            try viewContext.save()
            signUpErrorMessage = nil
            isLoggedIn = true  // After signing up, log in automatically and go to Mood Entry Page
        } catch {
            signUpErrorMessage = "Error saving user."
        }
    }
}
