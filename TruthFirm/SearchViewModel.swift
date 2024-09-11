import SwiftUI
import Firebase

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = "" {
        didSet {
            Task {
                await searchFirms()
            }
        }
    }
    @Published var searchResults: [FirmModel] = []
    @Published var isLoading = false
    @Published var showNoResultsMessage = false

    func searchFirms() async {
        guard !searchQuery.isEmpty else {
            DispatchQueue.main.async {
                self.searchResults = []
                self.showNoResultsMessage = false
            }
            return
        }
        
        isLoading = true
        let db = Firestore.firestore()
        let query = db.collection("firms")

        do {
            let snapshot = try await query.getDocuments()
            var firms = snapshot.documents.compactMap { doc in
                try? doc.data(as: FirmModel.self)
            }
            firms = firms.filter({ firm in
                firm.matchName.contains(searchQuery)
            })
            print(firms.count)

            DispatchQueue.main.async {
                self.searchResults = firms
                self.showNoResultsMessage = firms.isEmpty
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.showNoResultsMessage = true
            }
            print("Error searching firms: \(error.localizedDescription)")
        }
    }
}

