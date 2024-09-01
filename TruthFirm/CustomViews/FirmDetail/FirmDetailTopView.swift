//
//  FirmDetailTopView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct FirmDetailTopView: View {
    var firm : FirmModel
    var body: some View {
        VStack(alignment : .center){
            Text(firm.name)
                .font(.largeTitle)
                .padding(.bottom, 5)
                    // << default center !!

                
                Text("City : \(firm.city)")
                    .font(.body)
                    .padding(.bottom, 10)
                    

                Text( "Description : \(firm.description)")
                    .font(.body)
                    .padding(.bottom, 20)
        }
        .frame(width: 300)
      
        
    }
        
    
}

#Preview {
    FirmDetailTopView(firm: FirmModel(id: "UeIDGDpc6LDWk8c5NVxk", matchName: "osman game", name: "osman Game", city: "adana", description: "oyun şirketi" , reviews: ["8ImzWhtXx054x2MOSlgc"], ratings: [2]))
}
