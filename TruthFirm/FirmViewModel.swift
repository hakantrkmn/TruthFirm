import SwiftUI
import Firebase

@MainActor
class FirmViewModel: ObservableObject {
    @Published var firm: FirmModel?
    @Published var reviews: [Review] = []
    @Published var isLoading = false
    var choosenReview : Review?
    var alertItem : AlertItem?
    var userCanReview : Bool
    {
        get
        {
            if let userId = UserInfo.shared.user?.uid {
                return !reviews.contains { $0.userId == userId }
            }
            return true
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
                try await DBService.getUserInfo(userID: review.userId) { result in
                    switch result {
                    case .success(let success):
                        review.userInfo = success
                    case .failure(let failure):
                        self.alertItem = AlertItem(title: Text("Error"), message: Text("Failed to fetch review"), dismissButton: .default(Text("OK")))
                    }
                }
                
                try await DBService.getFirmInfo(firmID: review.firmId) { result in
                    switch result {
                    case .success(let success):
                        review.firmInfo = success
                    case .failure(let failure):
                        self.alertItem = AlertItem(title: Text("Error"), message: Text("Failed to fetch firm"), dismissButton: .default(Text("OK")))

                    }
                }
                
            }

            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            print("Error fetching firm details: \(error.localizedDescription)")
            self.alertItem = AlertItem(title: Text("Error"), message: Text("Error fetching firm details: \(error.localizedDescription)"), dismissButton: .default(Text("OK")))

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
