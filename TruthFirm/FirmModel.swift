import Foundation

struct Review: Identifiable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var username: String
    var rating: Int
    var reviewText: String
}

struct FirmModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    var matchName : String
    var name: String
    var city: String
    var description: String
    var reviews: [Review] = []
    var ratings : [Int] = []
}
