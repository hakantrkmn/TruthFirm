import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    var user : UserModel?
    @Published var alertItem : AlertItem?
    

    
    func loginUser(eo : AuthViewModel) async {
        guard !username.isEmpty, !password.isEmpty else {
            alertItem = AlertItem(title: Text("Error"), message: Text("Username and password cannot be empty"), dismissButton: .default(Text("OK")))

            showAlertMessage("Username and password cannot be empty")
            return
        }

        isLoading = true

        do {
            user = try await AuthService.loginUser(username: username, password: password)
            print("User logged in: \(user!.username)")
            eo.user = user
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

    }
}


