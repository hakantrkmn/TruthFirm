import SwiftUI
import Firebase

@main
struct TruthFirmApp: App {
    
    @StateObject  var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
            
        }
    }
}
