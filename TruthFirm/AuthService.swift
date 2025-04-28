import Firebase
import SwiftUI
import FirebaseFunctions
import CryptoKit

class AuthService {
    
    static let db = Firestore.firestore()
    
    static func registerUser(username: String, password: String,completionHandler : @escaping (Result<UserModel,AlertItem>) -> Void) async throws {
        let passwordHash = sha256(password)
        
        let usersRef = db.collection("users")
        let querySnapshot = try await usersRef.whereField("username", isEqualTo: username).getDocuments()
        
        if !querySnapshot.isEmpty {
            completionHandler(.failure(AlertItem(title: Text("Error"), message: Text("Username already taken"), dismissButton: .default(Text("OK")))))
            return
        }
        
        
        let userModel = UserModel(username: username, uid: usersRef.document().documentID,likedReviews: [],createdReviews: [])
        try await usersRef.document(userModel.uid).setData([
            "username": username,
            "passwordHash": passwordHash,
            "uid": userModel.uid,
            "likedReviews" : userModel.likedReviews,
            "createdReviews" : userModel.createdReviews
        ])
        UserInfo.shared.user = userModel
        saveUserInfo(userModel)

        completionHandler(.success(userModel))
    }
    static func signOut() throws {
        deleteUserInfo()
    }
    static func loginUser(username: String, password: String,completionHandler : @escaping (Result<UserModel,AlertItem>) -> Void) async throws  {
        let passwordHash = sha256(password)
        let usersRef = db.collection("users")
        let querySnapshot = try await usersRef.whereField("username", isEqualTo: username).getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            completionHandler(.failure(AlertItem(title: Text("Error"), message: Text("Username not found"), dismissButton: .default(Text("OK")))))
            return
        }
        
        let storedHash = document.get("passwordHash") as? String
        if storedHash != passwordHash {
            completionHandler(.failure(AlertItem(title: Text("Error"), message: Text("Invalid Password"), dismissButton: .default(Text("OK")))))
        }
        
        let userModel = try document.data(as: UserModel.self)
        saveUserInfo(userModel)
        UserInfo.shared.user = userModel

        completionHandler(.success(userModel))
    }
  
    
    static private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}


func saveUserInfo(_ userInfo: UserModel) {
    let defaults = UserDefaults.standard
    if let encoded = try? JSONEncoder().encode(userInfo) {
        defaults.set(encoded, forKey: "auth")
    }
}

func deleteUserInfo() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "auth")
}

func loadUserInfo() -> UserModel? {
    let defaults = UserDefaults.standard
    if let savedUserData = defaults.object(forKey: "auth") as? Data {
        if let decodedUser = try? JSONDecoder().decode(UserModel.self, from: savedUserData) {
            return decodedUser
        }
    }
    return nil
}
