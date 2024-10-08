import SwiftUI

struct SearchPage: View {
    @StateObject private var viewModel = SearchViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    var body: some View {
        GeometryReader{geometry in
                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else if viewModel.showNoResultsMessage {
                        Text("We don't have that firm in our database.")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 30) {
                                ForEach(viewModel.searchResults) { firm in
                                    
                                    NavigationLink(destination: FirmPage(firm: firm) ){
                                        FirmCardView(firm: firm)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    
                                }
                                .frame(width: max((geometry.size.width / 3.2) , 0),
                                       height: max((geometry.size.width / 3.2) , 0))
                                .padding()

                            }
                        }
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            .searchable(text: $viewModel.searchQuery)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .navigationTitle("Search Firms")
        }
    }
    
    
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SearchPage()
        }
    }
}
