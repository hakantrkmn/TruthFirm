import Foundation
import Firebase
@MainActor
class FirmCreateViewModel: ObservableObject {
    @Published var firmName: String = ""
    @Published var city: City? = nil
    @Published var cities: [City] = []
    @Published var firmDescription: String = ""
    @Published var rating: Int = 5
    @Published var review: String = ""
    @Published var errorMessage: String?
    @Published var isSaved: Bool = false
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false

    init() {
        loadCities()
    }

    func loadCities() {
            guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
                print("Cities JSON file not found")
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let decodedCities = try JSONDecoder().decode([City].self, from: data)
                DispatchQueue.main.async {
                    self.cities = decodedCities
                    if !self.cities.isEmpty {
                        self.city = self.cities[0]
                    }
                }
            } catch {
                print("Error loading cities: \(error)")
            }
        }

    func createFirm() async {
        guard let city = city, !firmName.isEmpty, !firmDescription.isEmpty, !review.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Please fill out all fields."
            }
            return
        }

        let user = loadUserInfo()
         isLoading = true // Start loading

        let newFirm = FirmModel(
            matchName : firmName.lowercaseRemoveBlank(),
            name: firmName,
            city: city.name,
            description: firmDescription,
            reviews: [],
            ratings : []
        )
        
        let db = Firestore.firestore()
        do {
            // Check if the firm already exists based on the name and city
            let firmQuery = db.collection("firms")
                .whereField("matchName", isEqualTo: firmName.lowercaseRemoveBlank())
                .limit(to: 1)
            
            let firmSnapshot = try await firmQuery.getDocuments()
            
            var firmRef: DocumentReference
            if let existingFirm = firmSnapshot.documents.first {
                DispatchQueue.main.async {
                    self.errorMessage = "Firm Existed"
                    self.isLoading = false // Stop loading
                    self.showError = true
                }
                return
            } else {
                // Create a new firm document if it doesn't exist
                firmRef = try await db.collection("firms").addDocument(data: [
                    "matchName" : newFirm.matchName,
                    "name": newFirm.name,
                    "city": newFirm.city,
                    "description": newFirm.description,
                    "reviews": [],
                    "ratings" : []
                ])
            }

            // Save the review in the "reviews" collection
            let reviewRef = try await db.collection("reviews").addDocument(data: [
                "firmId": firmRef.documentID,
                "userId": user?.uid, // Replace with actual user ID
                "rating": rating,
                "reviewText": review,
                "timestamp": Date.now,
                "likedUsers" : []
            ])
            
            // Update the firm document with the new review ID
            try await firmRef.updateData([
                "reviews": FieldValue.arrayUnion([reviewRef.documentID]),
                "ratings": FieldValue.arrayUnion([rating])

            ])
            
                self.isSaved = true
                self.isLoading = false // Stop loading
        } catch {
                self.errorMessage = "Error saving firm: \(error.localizedDescription)"
                self.isLoading = false // Stop loading
        }
    }

}
