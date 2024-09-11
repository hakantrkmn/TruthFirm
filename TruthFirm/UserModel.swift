import Foundation

struct UserModel: Identifiable , Hashable , Codable {
    var id: String { uid }
    var username: String
    var uid: String
    var passwordHash : String?
    var likedReviews : [String]
    // Add more fields if needed
}
