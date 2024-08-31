import SwiftUI

struct FirmCreatePage: View {
    @StateObject private var viewModel = FirmCreateViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            
           
                
            
            Form {
                Section(header: Text("Firm Details")) {
                    TextField("Firm Name", text: $viewModel.firmName)
                        .autocorrectionDisabled()
                    Picker("City", selection: $viewModel.city) {
                        ForEach(viewModel.cities) { city in
                            Text(city.name).tag(city as City?)
                        }
                    }
                    TextField("Description", text: $viewModel.firmDescription)
                        .autocorrectionDisabled()
                }
                
                Section(header: Text("Rating")) {
                    StarRatingView(rating: $viewModel.rating)
                        .padding(.vertical)
                }
                
                Section(header: Text("Review")) {
                    TextEditor(text: $viewModel.review)
                        .frame(height: 150)
                        .autocorrectionDisabled()
                }
                
                
                
                Button(action: {
                    Task {
                        await viewModel.createFirm()
                        if viewModel.isSaved {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Save Firm")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .listRowInsets(EdgeInsets())
                .disabled(viewModel.isLoading) // Disable button during loading
                
                
                
                
                
            }
            .blur(radius: viewModel.isLoading ? 3 : 0) // Blur the form when loading
            .overlay {
                if viewModel.isLoading {
                    LoadingView() // Show loading view when isLoading is true
                }
            }
            
            
        
    }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Create Firm")
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

struct FirmCreatePage_Previews: PreviewProvider {
    static var previews: some View {
        FirmCreatePage()
    }
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
