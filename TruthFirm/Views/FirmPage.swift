import SwiftUI

struct FirmPage: View {
    @StateObject  var viewModel = FirmViewModel()
    var firm : FirmModel
    var body: some View {
        if let firm = viewModel.firm {
            
            VStack{
                FirmDetailTopView(firm: firm)
                Text("Reviews")
                    .font(.largeTitle)
                    .bold()
                
                List(viewModel.reviews){review in
                    ReviewCardView(review: review)
                    
                }
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 4)
                .scrollContentBackground(.hidden)
                .padding()
                
                
                Spacer()
                
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            
            .navigationTitle("Firm Details")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if viewModel.isLoading {
                    LoadingView() // Show loading view when isLoading is true
                }
            }
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
            FirmPage(firm: FirmModel(id: "UeIDGDpc6LDWk8c5NVxk", matchName: "osman game", name: "osman Game", city: "adana", description: "oyun şirketi" , reviews: ["8ImzWhtXx054x2MOSlgc"], ratings: [2]))
        }
        
    }
}
