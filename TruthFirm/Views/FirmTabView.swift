//
//  TabView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 30.08.2024.
//

import SwiftUI
import Foundation
struct FirmTabView: View {
    
    var body: some View {
            TabView {
                NavigationStack
                {
                    FeedPage()
                }
                .tabItem { 
                    Image(systemName: "moon")
                    Text("Feed" )
                }
                NavigationStack
                {
                    SearchPage()
                        
                        
                }
                .tabItem {
                    Image(systemName: "moon")
                    Text("Search" )
                }
                
                NavigationStack
                {
                    ProfilePage()
                        
                        
                }
                .tabItem {
                    Image(systemName: "moon")
                    Text("Profile" )
                }

        }
            
        
        
        
    
    }
}

#Preview {
    FirmTabView()
}
