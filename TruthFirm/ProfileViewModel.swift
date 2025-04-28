import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var user : UserModel?
    @Published var reviews: [Review] = []
    @Published var likedReviews: [Review] = []

    func fetchUserData() async {
        let db = Firestore.firestore()
        
        
        guard let user = UserInfo.shared.user else{return }
        // Fetch user profile data
        let userRef = db.collection("users").document(user.uid)
        do {
            // Fetch reviews made by the user
            let reviewsSnapshot = try await db.collection("reviews").whereField("userId", isEqualTo: user.uid).getDocuments()
            self.reviews = reviewsSnapshot.documents.compactMap { doc in
                try? doc.data(as: Review.self)
            }
            
            // Fetch reviews liked by the user
            let likedSnapshot = try await db.collection("reviews")
                .whereField("likedUsers", arrayContains: user.uid)
                .getDocuments()
            self.likedReviews = likedSnapshot.documents.compactMap { doc in
                try? doc.data(as: Review.self)
            }
            
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
}
