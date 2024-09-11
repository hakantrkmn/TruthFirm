import SwiftUI

struct FirmReviewPage: View {
    @StateObject private var viewModel : FirmReviewViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(firm: FirmModel ) {
        _viewModel = StateObject(wrappedValue: FirmReviewViewModel(firm: firm))
        
    }
    var body: some View {
        ZStack{
            if viewModel.isSubmitting
            {
                LoadingView()
            }
            VStack(alignment: .center) {
                
                    
                // Firm Information
                FirmDetailTopView(firm: viewModel.firm)
                
                // Rating Section
                Text("Your Rating")
                    .font(.headline)
                
                StarRatingView(rating: $viewModel.rating)
                    .padding(.bottom, 20)
                
                // Review Text Area
                Text("Your Review")
                    .font(.headline)
                
                TextEditor(text: $viewModel.reviewText)
                    .frame(height: 150)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding(.bottom, 20)
                
                // Submit Button
                Button(action: {
                    Task {
                        do
                        {
                            try await viewModel.submitReview()
                            presentationMode.wrappedValue.dismiss()  // This pops the view off the stack
                            
                        }
                        catch
                        {
                            
                        }
                    }
                }) {
                    Text("Submit Review")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
            }
            .blur(radius: viewModel.isSubmitting ? 10 : 0)

        }
        .padding()
        .navigationTitle("Review Firm")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // This pops the view off the stack

                }, label: {
                    Text("Cancel")
                })
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        
    }
}

struct FirmReviewPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FirmReviewPage(firm: FirmModel.sampleFirm)
            
        }
        
    }
}
