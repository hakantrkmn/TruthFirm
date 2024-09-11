import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
class FeedViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var userSignedOut = false

    @Published var isLoading = false
    private var lastDocument: DocumentSnapshot?
    
    init() {
        Task{
            await fetchReviews()
        }
    }
    @MainActor func fetchReviews() async {
        
        guard !isLoading else { return }
        isLoading = true
        
        let db = Firestore.firestore()
        var query: Query = db.collection("reviews")
            .order(by: "timestamp", descending: false)
            .limit(to: 10)
        
        if let lastDoc = lastDocument {
            print("lastdoc var")
            query = query.start(afterDocument: lastDoc)
        }
        
        do {
            var newReviews : [Review] = []

            var snapshot = try await query.getDocuments()
            var _: [()] = try snapshot.documents.compactMap { doc in
                
                newReviews.append(try doc.data(as: Review.self))
            }
            
            for rev in newReviews {
                rev.userInfo = try await db.collection("users").document(rev.userId).getDocument(as:UserModel.self)
                
            }
            
            for rev in newReviews {
                rev.firmInfo = try await db.collection("firms").document(rev.firmId).getDocument(as:FirmModel.self)
            }
            
            
            
            if newReviews.count != 0
            {
                    self.reviews.append(contentsOf: newReviews)
                    self.lastDocument = snapshot.documents.last
                    self.isLoading = false
            }
            else
            {
                isLoading = false
            }
            
        } catch {
            print("Error fetching reviews: \(error.localizedDescription)")
                self.isLoading = false
        }
    }
    
    func signOut()
    {
        do{
            try Auth.auth().signOut()
            userSignedOut = true
        }
        catch
        {
            
        }
    }
    
}
