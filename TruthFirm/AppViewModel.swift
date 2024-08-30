import SwiftUI
import Firebase
import FirebaseAuth

class AppViewModel: ObservableObject {
    @Published var user: UserModel? = nil
    @Published var isLoading = true
    
    init() {
        Task {
            await checkUser()
        }
    }
    
    func checkUser() async {
        if let firebaseUser = Auth.auth().currentUser {
            do {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(firebaseUser.uid)
                
                let document = try await userRef.getDocument()
                
                if let data = document.data() {
                    let username = data["username"] as? String ?? ""
                    let passwordHash = data["passwordHash"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.user = UserModel(username: username, uid: firebaseUser.uid, passwordHash: passwordHash)
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } catch {
                print("Error fetching user data: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func signOut() {
            do {
                try Auth.auth().signOut()
                DispatchQueue.main.async {
                    self.user = nil
                    self.isLoading = false
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
}
