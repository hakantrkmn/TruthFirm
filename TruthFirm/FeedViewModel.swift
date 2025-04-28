import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
@MainActor
class FeedViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var userSignedOut = false

    @Published var isLoading = false
    var choosenReview : Review?
    
    private var lastDocument: DocumentSnapshot?

    init() {
        Task{
            await fetchReviews()
        }
    }
    
    func updateReviews() async
    {
        Task
        {
            do
            {
                for (index,review) in reviews.enumerated() {
                    try await DBService.getReview(reviewID: review.id!) { result in
                        switch result {
                        case .success(let success):
                            self.reviews[index] = success
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
            }
            catch
            {
                
            }
        }
        
    }
    
    
     func fetchReviews() async {
        
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

            let snapshot = try await query.getDocuments()
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
            UserInfo.shared.user = nil
            deleteUserInfo()
            userSignedOut = true
        }
        catch
        {
            
        }
    }
    
}
