import SwiftUI

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    var user = UserModel(username: "", uid: "", passwordHash: "")
    @Published var registered: Bool = false

    var passwordsMatch: Bool {
        return !password.isEmpty && password == confirmPassword
    }

    func registerUser() async {
        guard !username.isEmpty else {
            showAlertMessage("Username cannot be empty")
            return
        }

        guard passwordsMatch else {
            showAlertMessage("Passwords do not match")
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            user = try await AuthService.registerUser(username: username, password: password)
            print("User registered: \(user.username)")
            isLoading = false
            registered = true

            // Handle successful registration, perhaps navigate to the main content
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
