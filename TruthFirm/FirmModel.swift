import Foundation
import FirebaseFirestore

class Review: Identifiable, Codable , ObservableObject {
    @DocumentID var id: String?
    var userId: String
    var rating: Int
    var reviewText: String
    var firmId : String
    var userInfo : UserModel?
    var firmInfo : FirmModel?
    var timestamp : Date
    var likedUsers : [String]
    
    
    
    init(id: String? = nil, userId: String, rating: Int, reviewText: String, firmId: String, userInfo: UserModel? = nil, firmInfo: FirmModel? = nil, timestamp: Date, likedUsers: [String]) {
        self.id = id
        self.userId = userId
        self.rating = rating
        self.reviewText = reviewText
        self.firmId = firmId
        self.userInfo = userInfo
        self.firmInfo = firmInfo
        self.timestamp = timestamp
        self.likedUsers = likedUsers
    }
    
    public static var sampleReview  = Review(userId: "1234", rating: 4, reviewText: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", firmId: "894028",userInfo: UserModel(username: "hakan", uid: "19283987231", likedReviews: []),firmInfo: FirmModel(matchName: "agalarla", name: "agalarla Games", city: "Trabzon", description: "oyun"), timestamp: Date.now , likedUsers: [])

    
}

struct FirmModel: Identifiable, Codable , Hashable {
    @DocumentID var id: String?
    var matchName : String
    var name: String
    var city: String
    var description: String
    var reviews: [String] = []
    var ratings : [Int] = []
    var average : Float?
    {
        get
        {
             Float(ratings.reduce(0,+)/ratings.count)
        }
    }
    
    

    
    public static var sampleFirm = FirmModel(matchName: "agalarlagames", name: "agalarla Games", city: "Trabzon", description: "oyun şirketi" , reviews: ["alksndaşskd" , "akndşlakds"] , ratings: [1,2,5,6,7,10])
}

