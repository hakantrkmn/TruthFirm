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


    func loginUser() async {
        guard !username.isEmpty, !password.isEmpty else {
            showAlertMessage("Username and password cannot be empty")
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            user = try await AuthService.loginUser(username: username, password: password)
            print("User logged in: \(user.username)")
            registered=true
            isLoading = false
            // Handle successful login, maybe update a user session in the app
        } catch {
            showAlertMessage(error.localizedDescription)
            isLoading = false

        }
    }

    private func showAlertMessage(_ message: String) {
        errorMessage = message
        showAlert = true
    }
}
