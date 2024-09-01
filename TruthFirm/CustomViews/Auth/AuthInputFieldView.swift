//
//  AuthTextFieldView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct AuthInputFieldView: View {
    @Binding var textValue : String
    var body: some View {
        TextField("Username", text: $textValue)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .frame(width: 300)
            .overlay(  // add an overlay
                 RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)) // create a rounded rectangle
                     .stroke(Color.gray, lineWidth: 1)                     // and set its border color to gray with a line widht of 1
             )
    }
}

#Preview {
    AuthInputFieldView(textValue: .constant("test"))
}
