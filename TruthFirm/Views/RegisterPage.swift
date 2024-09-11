import SwiftUI

struct RegisterPage: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel

    var body: some View {
            VStack {
                VStack {
                    Text("TruthFirm")
                        .font(.largeTitle)
                        .padding()
                    
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 40)
                
                
                VStack(spacing: 20) {
                    AuthInputFieldView(textValue: $viewModel.username)
                        
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                    
                    SecureField("Confirm your password", text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .onChange(of: viewModel.confirmPassword) { _ in
                            _ = viewModel.passwordsMatch
                        }
                    
                    if !viewModel.passwordsMatch && !viewModel.confirmPassword.isEmpty {
                        Text("Passwords do not match")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.registerUser()
                            authViewModel.user = viewModel.user
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300)
                                .background(viewModel.passwordsMatch ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(!viewModel.passwordsMatch || viewModel.isLoading)
                }
                .padding()
                
                Spacer()
                
                
            }
        .padding()
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            RegisterPage()
        })
    }
}
