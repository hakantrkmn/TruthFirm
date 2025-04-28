import SwiftUI

struct ProfilePage: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // User Statistics
                    Text("Username: \(viewModel.user?.username)")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    HStack {
                        
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 20)

                    // User's Reviews
                    Text("Your Reviews")
                        .font(.headline)
                    
                    ForEach(viewModel.reviews) { review in
                        VStack(alignment: .leading) {
                            Text("Rating: \(review.rating)/10")
                                .font(.headline)
                            Text(review.reviewText)
                                .font(.body)
                                .padding(.bottom, 10)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                    }
                    
                    // Liked Reviews
                    Text("Liked Reviews")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    ForEach(viewModel.likedReviews) { review in
                        VStack(alignment: .leading) {
                            Text("Rating: \(review.rating)/10")
                                .font(.headline)
                            Text(review.reviewText)
                                .font(.body)
                                .padding(.bottom, 10)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    await viewModel.fetchUserData()
                }
            }
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
