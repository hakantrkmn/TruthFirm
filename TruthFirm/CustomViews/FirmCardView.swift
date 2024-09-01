//
//  FirmCardView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct FirmCardView: View {
    @Environment(\.colorScheme) var colorScheme
    var firm : FirmModel
    var body: some View {
        VStack(alignment: .center) {
            Text(firm.name)
                .font(.headline)
            Text(firm.city)
                .font(.subheadline)
            Text(firm.description)
                .font(.body)
                .lineLimit(3)
            Text(String(firm.average!) + "/10")
                .font(.subheadline)
            Text(String(firm.reviews.count) + " reviews")
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 4)

    }
}

#Preview {
    FirmCardView(firm: FirmModel.sampleFirm)
}
