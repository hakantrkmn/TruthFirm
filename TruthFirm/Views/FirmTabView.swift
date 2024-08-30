//
//  TabView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 30.08.2024.
//

import SwiftUI
import Foundation
struct FirmTabView: View {
    
    var user : UserModel
    var body: some View {
            TabView {
                FeedPage(user : user)
                    .tabItem { Label("Feed" , systemImage: "list.dash") }

            }
            .navigationBarBackButtonHidden(true)
        
        
        
    
    }
}

#Preview {
    FirmTabView(user: UserModel(username: "asd", uid: "dsa", passwordHash: "dsd"))
}
