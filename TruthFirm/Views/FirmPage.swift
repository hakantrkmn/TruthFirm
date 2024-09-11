import SwiftUI

struct FirmPage: View {
    @StateObject  var viewModel = FirmViewModel()
    var firm : FirmModel
    @State var isShowingDetail = false
    @State var choosenReview : Review?
    @State var showReview = false
    var body: some View {
        if let firm = viewModel.firm {
            ZStack{
                VStack{
                    FirmDetailTopView(firm: firm)
                    
                    
                    ZStack {
                        // Layer 1: This HStack will manage the "Filter" button on the right
                        HStack {
                            Spacer() // Pushes the "Filter" button to the right
                            Menu {
                                Button(action: {}, label: {
                                    Text("Like")
                                })
                                .frame(width: 50)
                                
                                Button(action: {}, label: {
                                    Text("Date")
                                })
                                .frame(width: 50)
                            } label: {
                                Text("Filter")
                            }
                        }
                        
                        // Layer 2: This will center the "Reviews" text
                        HStack {
                            Spacer() // Ensures the text is centered
                            Text("Reviews")
                                .font(.largeTitle)
                                .bold()
                            Spacer() // Maintains centering
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                   
                    
                    List(viewModel.reviews){review in
                        ReviewCardView(review: review)
                            .onTapGesture {
                                withAnimation {
                                    isShowingDetail = true
                                    choosenReview = review
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .safeAreaInset(edge: .bottom, content: {
                        if viewModel.userCanReview
                        {
                                    Button(action: {
                                        showReview = true
                                    }, label: {
                                        Text("Add Review")
                                    })
                                    .frame(maxWidth: UIScreen.screenWidth / 2,maxHeight: 60)
                                    .background(.green)
                                    .cornerRadius(10)
                                    .tint(.white)
                                    .padding(.bottom)
                                
                            
                        }
                    })
                    .listStyle(.plain)
                    .cornerRadius(10)
                    .scrollContentBackground(.hidden)
                    

                    
                    Spacer()
                    
                }
                .navigationTitle("Firm Details")
                .navigationBarTitleDisplayMode(.inline)
                .overlay {
                    if viewModel.isLoading {
                        LoadingView() // Show loading view when isLoading is true
                    }
                }
                .blur(radius: isShowingDetail ? 3 : 0)
                if isShowingDetail
                {
                    ReviewDetailView(review: choosenReview!, isShowingDetail: $isShowingDetail)
                    
                }
                
                
            }
            .onAppear(perform: {
                dump(viewModel.firm)
            })
            .sheet(isPresented: $showReview, content: {
                FirmReviewPage(firm: viewModel.firm!)
            })
            
            
            
        } else {
            LoadingView()
                .padding()
                .onAppear{
                    Task{
                        viewModel.firm = self.firm
                        await viewModel.fetchFirmDetails()
                    }
                }
            
        }
            
        
    }
}

struct FirmPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FirmPage(firm: FirmModel(id: "egShvAoU7ruri3zYuvHT", matchName: "osman game", name: "osman Game", city: "adana", description: "oyun şirketi" , reviews: ["RVoYVFHjRntpdiw1n64J","13wNpGiZnOQZOt3g0VRH","oR284emSpvktSN3UlkG6"], ratings: [2]))
        }
        
    }
}
