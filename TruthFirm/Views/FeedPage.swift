import SwiftUI

struct FeedPage: View {
    @StateObject private var viewModel = FeedViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    @State var showDetailView = false
    @State var choosenReview : Review?
    var body: some View {
        ZStack{
            if viewModel.isLoading {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if viewModel.reviews.isEmpty {
                Text("No more reviews.")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            List {
                ForEach(viewModel.reviews) { review in
                        FeedPostCardView(review: review)
                            .onTapGesture {
                                choosenReview = review
                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    showDetailView = true
                                    
                                }
                            }
                        
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                
                
               
                
                
            }
            .listStyle(.plain)
            .refreshable {
                Task {
                    await viewModel.fetchReviews()
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FirmCreatePage()) {
                        Text("Create Firm")
                    }
                }
            }
            .blur(radius: showDetailView ? 3 : 0)
            if showDetailView
            {
                ReviewDetailView(review: choosenReview!, isShowingDetail: $showDetailView)
                    .transition(.scale)
                
            }
        }
        .onAppear(perform: {
            Task
            {
                do {
                    try await DBService.getReview(reviewID: "13wNpGiZnOQZOt3g0VRH") { result in
                        switch result {
                        case .success(let success):
                            dump(success)
                        case .failure(let failure):
                            dump(failure)
                        }
                    }
                } catch let err {
                    dump(err)
                }
            }
            dump(UserInfo.shared.user)
        })
        .navigationDestination(for: FirmModel.self) { firm in
            
            FirmPage(firm: firm)
                .onAppear(perform: {
                    showDetailView = false
                })
               
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
