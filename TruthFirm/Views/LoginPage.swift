import SwiftUI

struct LoginPage: View {
    @StateObject private var viewModel = LoginViewModel()
    @State var goregister = false
    var body: some View {
        NavigationView{
            if viewModel.isLoading
            {
                LoadingView()
                
            }
            else
            {
                
            VStack {
                VStack {
                    Text("TruthFirm")
                        .font(.largeTitle)
                        .padding(.top, 60)
                    
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 40)
                
                
                VStack(spacing: 20) {
                    TextField("Enter your username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .frame(width: 300)
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                    
                    Button(action: {
                        Task {await viewModel.loginUser()}
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300)
                            .background(Color.blue)
                            .cornerRadius(10)
                        
                    }
                    .disabled(viewModel.isLoading)
                }
                
                Spacer()
                
                Text("Create new user")
                    .onTapGesture { goregister = true}
                    .foregroundStyle(.blue)
                
                
                
                NavigationLink(destination: FirmTabView(user: viewModel.user), isActive: $viewModel.registered) {
                    EmptyView()
                }
                NavigationLink(destination: RegisterPage(), isActive: $goregister) {
                    EmptyView()
                }
                
                
                
            }
        }
        }

        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
