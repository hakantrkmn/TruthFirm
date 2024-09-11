import SwiftUI
import Firebase

class FirmReviewViewModel: ObservableObject {
    @Published var rating: Int = 0
    @Published var reviewText: String = ""
    @Published var firm : FirmModel
    @Published var alertItem : AlertItem?
    @Published var isSubmitting = false
    init(firm  : FirmModel) {
            self.firm = firm
        }
    func submitReview() async throws {
        
        let db = Firestore.firestore()
        isSubmitting = true
        do {
            let reviewRef = try await db.collection("reviews").addDocument(data: [
                "firmId": firm.id!,
                "userId": UserInfo.shared.user!.uid,
                "rating": rating,
                "reviewText": reviewText,
                "timestamp": Timestamp(),
                "likedUsers" : []
            ])
            
            // Update the firm's review references
            try await db.collection("firms").document(firm.id!).updateData([
                "reviews": FieldValue.arrayUnion([reviewRef.documentID])
            ])
            
            
            
            isSubmitting = false
            DispatchQueue.main.async {
                self.rating = 0
                self.reviewText = ""
            }
        } catch {
            isSubmitting = false
            alertItem = AlertItem(title: Text("Error"), message: Text("Something happened when review"), dismissButton: .default(Text("OK")))
            print("Error submitting review: \(error.localizedDescription)")
        }
    }
}
