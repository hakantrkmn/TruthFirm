import SwiftUI

struct RegisterPage: View {
    @StateObject private var viewModel = RegisterViewModel()

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
                    .padding(.top, 10)
            }
            .ignoresSafeArea()
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
            NavigationLink(destination: FirmTabView(user: viewModel.user), isActive: $viewModel.registered) {
                                EmptyView()
                            }
            Spacer()

            
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

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            RegisterPage()
        })
    }
}
