import SwiftUI

struct FeedPage: View {
    @StateObject var viewModel = FeedViewModel()
    var user : UserModel
    var body: some View {
        NavigationView{
            VStack {
                Text("Welcome to TruthFirm")
                    .font(.largeTitle)
                    .padding()
                
                Text("Username: \(user.username)")
                    .font(.title2)
                    .padding()
                
                Text("User ID: \(user.uid)")
                    .font(.title2)
                    .padding()
                
                Text("Password Hash: \(user.passwordHash)")
                    .font(.title2)
                    .padding()
                
                // Add more fields as needed
                Button("Bordered Button") {
                    print("sa")
                         viewModel.sigOut()
                        
                    
                }
                .buttonStyle(.bordered)
                
                
                Spacer()
                    .fullScreenCover(isPresented: $viewModel.userSignedOut, content: {
                        LoginPage()
                    })
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Feed")
            .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: FirmCreatePage()) {
                                Text("Create Firm")
                            }
                        }
                    }
            
        }
        
        
        
    }
}

struct FeedPage_Previews: PreviewProvider {
    static var previews: some View {
        FeedPage(user: UserModel(username: "SampleUser", uid: "12345", passwordHash: "hashedpassword"))
    }
}
