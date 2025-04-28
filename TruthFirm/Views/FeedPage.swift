import SwiftUI

struct FeedPage: View {
    @StateObject private var viewModel = FeedViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    @State var showDetailView = false
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            if viewModel.isLoading 
            {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } 
            else if viewModel.reviews.isEmpty
            {
                Text("No more reviews.")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            List 
            {
                ForEach(viewModel.reviews) { review in
                    FeedPostCardView(review: review)
                        .onTapGesture {
                            viewModel.choosenReview = review
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
                ReviewDetailView(isShowingDetail: $showDetailView ,choosenReview: $viewModel.reviews.first { rev in
                    rev.id == viewModel.choosenReview!.id
                }!)
                        .transition(.scale)
                
                
                
            }
        }
        .navigationDestination(for: FirmModel.self) { firm in
            
            FirmPage(firm: firm)
                .onAppear(perform: {
                    showDetailView = false
                })
            
        }
        .onReceive(timer, perform: { _ in
            Task
            {
                await self.viewModel.updateReviews()

            }
        })
        
        
        
        
    }
    
}


struct FeedPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FeedPage()
            
        }
    }
}
