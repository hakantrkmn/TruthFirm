import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    var user = UserModel(username: "", uid: "", passwordHash: "")
    @Published var registered: Bool = false
    
    @Published var alertItem : AlertItem?
    

    
    func loginUser(eo : AuthViewModel) async {
        guard !username.isEmpty, !password.isEmpty else {
            alertItem = AlertItem(title: Text("Error"), message: Text("Username and password cannot be empty"), dismissButton: .default(Text("OK")))

            showAlertMessage("Username and password cannot be empty")
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            user = try await AuthService.loginUser(username: username, password: password)
            print("User logged in: \(user.username)")
            eo.user = user
            registered=true
            isLoading = false
            // Handle successful login, maybe update a user session in the app
        } catch {
            alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            showAlertMessage(error.localizedDescription)
            isLoading = false

        }
    }

    private func showAlertMessage(_ message: String) {
        alertItem = AlertItem(title: Text("Error"), message: Text(message), dismissButton: .default(Text("OK")))

        errorMessage = message
        showAlert = true
    }
}

struct AlertItem : Identifiable{
    let id = UUID()
    let title: Text
    let message : Text
    let dismissButton : Alert.Button
}
