//
//  RootView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 31.08.2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
        Group
        {
            if authViewModel.user != nil {
                // User is logged in, navigate to the FeedPage directly
                FirmTabView()
                    .environmentObject(authViewModel)
            } else {
                // No user is logged in, show the LoginPage
                LoginPage()
                    .environmentObject(authViewModel)
            }
        }
        
    }
    
}

#Preview {
    RootView()
}
