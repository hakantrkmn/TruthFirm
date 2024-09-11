import SwiftUI


class AuthViewModel : ObservableObject{
    

    @Published var user : UserModel?
    @Published var isLoading = true
    @MainActor
    init(){
        Task
        {
            if loadUserInfo() != nil{
                do
                {
                    var checkUser : UserModel?
                    try await DBService.getUserInfo(userID: loadUserInfo()!.uid) { result in
                        switch result {
                        case .success(let success):
                            checkUser = success
                            print("buldu")
                        case .failure(let failure):
                            checkUser = nil
                            print("bulamadı")

                        }
                    }
                    if checkUser == nil
                    {
                        user = nil
                    }
                    else
                    {
                        print("bulamadı")
                        user = checkUser
                        UserInfo.shared.user = checkUser
                        saveUserInfo(user!)
                    }
                }
                catch{
                    user = nil
                }
                isLoading = false
                
            }
            else{
                
                user = nil
                isLoading = false

            }
        }
        
    }
}
