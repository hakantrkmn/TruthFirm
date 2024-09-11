import SwiftUI
import Firebase

@MainActor
class FirmViewModel: ObservableObject {
    @Published var firm: FirmModel?
    @Published var reviews: [Review] = []
    @Published var isLoading = false
    var userCanReview : Bool
    {
        get
        {
            return !firm!.reviews.contains(UserInfo.shared.user!.uid)
        }
    }
    

    func filterReviews()
    {
        reviews = reviews.sorted(by: { rev1, rev2 in
            rev1.likedUsers.count > rev2.likedUsers.count
        })
    }
    func fetchFirmDetails() async {
        isLoading = true
        let db = Firestore.firestore()
        do {
            
            

            let reviewsSnapshot = try await db.collection("reviews")
                .whereField("firmId", isEqualTo: firm?.id)
                .order(by: "timestamp", descending: true)
                .getDocuments()
            
            self.reviews = reviewsSnapshot.documents.compactMap { doc in
                try? doc.data(as: Review.self)
            }
            
            for review in reviews {
                let revUser = try await db.collection("users")
                    .whereField("uid", isEqualTo: review.userId)
                    .getDocuments()
                
                review.userInfo = try? revUser.documents.first?.data(as: UserModel.self)
                
                let revFirm = db.collection("firms").document(review.firmId)
                review.firmInfo = try await revFirm.getDocument(as: FirmModel.self)
            }

            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            print("Error fetching firm details: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
