import SwiftUI


class AuthViewModel : ObservableObject{
    

    @Published var user : UserModel?
    
    init(){
        if UserDefaults.standard.value(forKey: "auth") != nil{
            user =  loadUserInfo()
          
        }
    }
}
