import SwiftUI

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var alertItem : AlertItem?

    var passwordsMatch: Bool {
        return !password.isEmpty && password == confirmPassword
    }

    func registerUser() async {
        guard !username.isEmpty else {
            alertItem = AlertItem(title: Text("Error"), message: Text("Username cannot be empty"), dismissButton: .default(Text("OK")))
            return
        }

        guard passwordsMatch else {
            alertItem = AlertItem(title: Text("Error"), message: Text("Password do not match"), dismissButton: .default(Text("OK")))
            return
        }

        isLoading = true

        do {
            try await AuthService.registerUser(username: username, password: password) { result in
                switch result {
                case .success(let success):
                    print("User registered: \(success.username)")
                    self.isLoading = false
                case .failure(let failure):
                    self.alertItem = failure
                }
            }
        } catch {
            alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            isLoading = false
        }
    }

}
