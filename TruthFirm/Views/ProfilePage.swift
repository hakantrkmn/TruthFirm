//
//  ProfilePage.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 31.08.2024.
//

import SwiftUI

struct ProfilePage: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
        Button(action: {
            do {
                try AuthService.signOut()
                authViewModel.user=nil
                
            } catch  {
                
            }
            
            
        }, label: {
            Text("sign out")
        })
    }
}

#Preview {
    ProfilePage()
}
