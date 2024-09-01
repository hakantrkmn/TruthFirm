//
//  AuthTopView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct AuthTopView: View {
    var body: some View {
        VStack {
            Text("TruthFirm")
                .font(.largeTitle)
                .padding()
            
            Image("appicon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 40)
    }
}

#Preview {
    AuthTopView()
}
