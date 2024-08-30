//
//  FeedViewModel.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 30.08.2024.
//

import Foundation


class FeedViewModel : ObservableObject {
    
    @Published var userSignedOut = false
    
    
    func sigOut()
    {
        do
        {
            try AuthService.signOut()
            userSignedOut = true
        }
        catch
        {
            
        }
    }
}
