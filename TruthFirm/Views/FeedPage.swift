import SwiftUI

struct FeedPage: View {
    @StateObject private var viewModel = FeedViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.reviews , id: \.firmId) { review in
                
                FeedPostCardView(review: review)
            }
            
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if viewModel.reviews.isEmpty {
                Text("No more reviews.")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
        .refreshable {
            Task {
                await viewModel.fetchReviews()
            }
        }
        .padding()
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: FirmCreatePage()) {
                    Text("Create Firm")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchReviews()
            }
        }
        
        
    }
}


struct FeedPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FeedPage()
            
        }
    }
}
