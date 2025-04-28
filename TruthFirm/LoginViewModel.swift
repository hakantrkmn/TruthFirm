import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    var user : UserModel?
    @Published var alertItem : AlertItem?
    
    @MainActor func loginUser(eo : AuthViewModel) async {
        guard !username.isEmpty, !password.isEmpty else {
            alertItem = AlertItem(title: Text("Error"), message: Text("Username and password cannot be empty"), dismissButton: .default(Text("OK")))
            return
        }

        isLoading = true

        do {
            try await AuthService.loginUser(username: username, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        self.user = success
                        print("User logged in: \(self.user!.username)")
                        eo.user = self.user
                        self.isLoading = false
                    case .failure(let failure):
                        self.alertItem = failure
                        self.isLoading = false
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
                self.isLoading = false
            }
        }
    }
}
