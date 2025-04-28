import Foundation

struct UserModel: Identifiable  , Codable {
    var id: String { uid }
    var username: String
    var uid: String
    var passwordHash : String?
    var likedReviews : [String]
    var createdReviews : [String]
    // Add more fields if needed
}
