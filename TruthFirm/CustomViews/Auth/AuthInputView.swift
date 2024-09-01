//
//  AuthInputView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct AuthInputView: View {
    @Binding var username : String
    @Binding var password : String
    @Binding var isloading : Bool
    var loginFunc :  () async -> Void
    var body: some View {
        VStack(spacing: 20) {
            AuthInputFieldView(textValue: $username)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .overlay(  // add an overlay
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4)) // create a rounded rectangle
                        .stroke(Color.gray, lineWidth: 1)                     // and set its border color to gray with a line widht of 1
                )
            
            Button(action: {
                Task {
                    await loginFunc()
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300)
                    .background(Color.blue)
                    .cornerRadius(10)
                
                
            }
            .disabled(isloading)
        }
        
        
        NavigationLink(destination: RegisterPage()) {
            Text("Create new user")
        }
        .padding()
    }
}

#Preview {
    AuthInputView(username: .constant("hakan"), password: .constant("12344"), isloading: .constant(false), loginFunc: {
        // Example of async operations
        print("Login function executed")
    })
}
