//
//  LoadingView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 30.08.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView(label: {
            Text("Loading")
                .bold()
                .fontWeight(.bold)
                .font(.largeTitle)
                .controlSize(.large)
            
                
        })
        .frame(width: .infinity , height: 400)
            
    }
}

#Preview {
    LoadingView()
}
