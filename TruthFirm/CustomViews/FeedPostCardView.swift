//
//  FeedPostCardView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct FeedPostCardView: View {
    @Environment(\.colorScheme) var colorScheme
    var review : Review
    
    var body: some View {
        VStack
        {
            Text(review.reviewText)
                .font(.body)
                .lineLimit(10)
                .padding(.bottom)
            
            HStack(alignment: .center){
                VStack{
                    Text("Rating: \(review.rating)/10")
                        .font(.headline)
                    
                    Text(review.userInfo!.username)
                        .font(.body)
                }
                Spacer()
                VStack{
                    NavigationLink(destination: ProfilePage()) {
                        Text(review.firmInfo!.name)
                            .font(.body)
                    }
                    
                    Text(review.timestamp.getFormattedDate())
                        .font(.body)
                }
                
            }
        }
        .padding()
        .background()
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2), radius: 4)

        
    }
        
}

#Preview {
    FeedPostCardView(review: Review.sampleReview)
        .padding()
}
