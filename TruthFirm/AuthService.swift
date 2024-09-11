import Firebase
import FirebaseFunctions
import CryptoKit

class AuthService {
    
    static let db = Firestore.firestore()
    
    static func registerUser(username: String, password: String) async throws -> UserModel {
        let passwordHash = sha256(password)
        
        let usersRef = db.collection("users")
        let querySnapshot = try await usersRef.whereField("username", isEqualTo: username).getDocuments()
        
        if !querySnapshot.isEmpty {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username already taken"])
        }
        
        
        let userModel = UserModel(username: username, uid: usersRef.document().documentID,likedReviews: [])
        try await usersRef.document(userModel.uid).setData([
            "username": username,
            "passwordHash": passwordHash,
            "uid": userModel.uid,
            "likedReviews" : userModel.likedReviews
        ])
        UserInfo.shared.user = userModel
        saveUserInfo(userModel)

        return userModel
    }
    static func signOut() throws {
        deleteUserInfo()
    }
    static func loginUser(username: String, password: String) async throws -> UserModel {
        let passwordHash = sha256(password)
        let usersRef = db.collection("users")
        let querySnapshot = try await usersRef.whereField("username", isEqualTo: username).getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])
        }
        
        let storedHash = document.get("passwordHash") as? String
        if storedHash != passwordHash {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid password"])
        }
        
        let userModel = try document.data(as: UserModel.self)
        saveUserInfo(userModel)
        UserInfo.shared.user = userModel

        return userModel
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
