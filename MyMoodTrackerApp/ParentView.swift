import SwiftUI

struct ParentView: View {  // Main view
    @State private var isLoggedIn = false  // State to track if user is logged in

    var body: some View {
        LoginPageView(isLoggedIn: $isLoggedIn)  // Pass the binding to LoginPageView
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}
