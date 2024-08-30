import SwiftUI
import Firebase

@main
struct TruthFirmApp: App {
    
    @StateObject private var appViewModel = AppViewModel()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if appViewModel.isLoading {
                // Show a loading view while checking authentication
                VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                            Text("Loading...")
                                .font(.headline)
                                .padding(.top, 20)
                        }
            } else if let user = appViewModel.user {
                // User is logged in, navigate to the FeedPage directly
                FeedPage(user : user)
            } else {
                // No user is logged in, show the LoginPage
                LoginPage()
            }
        }
    }
}
