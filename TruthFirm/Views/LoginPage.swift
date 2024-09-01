import SwiftUI

struct LoginPage: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        
        NavigationStack{
            
            VStack {
                AuthTopView()
                
                AuthInputView(username: $viewModel.username, password: $viewModel.password, isloading: $viewModel.isLoading) {
                    await viewModel.loginUser(eo: authViewModel)
                }
                Spacer()
            }
        }
        .padding()
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .blur(radius: viewModel.isLoading ? 3 : 0) // Blur the form when loading
        .overlay {
            if viewModel.isLoading {
                LoadingView() // Show loading view when isLoading is true
            }
        }
    }
    
    
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
            .environmentObject(AuthViewModel())
    }
}
