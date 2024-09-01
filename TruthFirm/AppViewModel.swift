/*import SwiftUI
import Firebase
import FirebaseAuth
class AppViewModel: ObservableObject {
    @Published var user: UserModel? = nil
    @Published var isLoading = true
    @EnvironmentObject var userInfo : UserInfo
    init() {
        Task {
            await checkUser()
        }
    }
    
    func checkUser() async {
        if let firebaseUser = Auth.auth().currentUser {
            do {
                print("authda biri var")
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(firebaseUser.uid)
                
                let document = try await userRef.getDocument()
                
                if let data = document.data() {
                    print("adamı bulduk")
                    let username = data["username"] as? String ?? ""
                    let passwordHash = data["passwordHash"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.user = UserModel(username: username, uid: firebaseUser.uid, passwordHash: passwordHash)
                        self.userInfo.user = self.user!
                        self.isLoading = false
                    }
                } else {
                    print("data sıkıntılı")
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
            print("authta kimse yok")

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

*/
