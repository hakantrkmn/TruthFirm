//
//  ReviewCardView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct ReviewCardView: View {
    @Environment(\.colorScheme) var colorScheme
    var review : Review
    var body: some View {
        VStack{
            Text(review.reviewText)
                .font(.body)
                .lineLimit(4)
                .padding(.bottom, 10)

            Text(review.userInfo?.username ?? "hakntrkmn")
                .font(.body)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.trailing , 5)
            
            Text("Rating: \(review.rating)/10")
                .font(.headline)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.trailing , 5)
            
        }
        .padding()
        .background()
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 5)


        
    }
}

#Preview {
    ReviewCardView(review: Review(userId: "1234", rating: 2, reviewText: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", firmId: "124124", timestamp: Date.now,likedUsers: []))
}
