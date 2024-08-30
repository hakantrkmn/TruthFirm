import Firebase
import FirebaseFunctions
import CryptoKit
import FirebaseAuth

class AuthService {
    
    static let db = Firestore.firestore()

    static func registerUser(username: String, password: String) async throws -> UserModel {
        let passwordHash = sha256(password)
        
        let usersRef = db.collection("users")
        let querySnapshot = try await usersRef.whereField("username", isEqualTo: username).getDocuments()
        
        if !querySnapshot.isEmpty {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username already taken"])
        }
        
        let authResult = try await Auth.auth().signInAnonymously()
        let user = authResult.user
        
        let userModel = UserModel(username: username, uid: user.uid, passwordHash: passwordHash)
        try await usersRef.document(user.uid).setData([
            "username": username,
            "passwordHash": passwordHash,
            "uid": user.uid
        ])
        
        return userModel
    }
    static func signOut() throws {
        try Auth.auth().signOut()
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
        
        let authResult = try await Auth.auth().signInAnonymously()
        let user = authResult.user
        
        return UserModel(username: username, uid: user.uid, passwordHash: passwordHash)
    }
    
    static private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
