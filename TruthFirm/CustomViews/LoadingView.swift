//
//  LoadingView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 30.08.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
}

#Preview {
    LoadingView()
}
