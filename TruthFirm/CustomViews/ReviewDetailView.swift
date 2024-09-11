//
//  ReviewDetailView.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 1.09.2024.
//

import SwiftUI

struct ReviewDetailView: View {
    @Binding var isShowingDetail : Bool
    
    @StateObject var viewModel : ReviewDetailViewModel
    
    init(review: Review , isShowingDetail : Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ReviewDetailViewModel(review: review))
        _isShowingDetail = isShowingDetail
        
    }
    var body: some View {
        VStack{
            ScrollView{
                Text(viewModel.review.reviewText)
            }
            .padding()
            .frame(width: 300, height: 400)
            
            HStack{
                Text(viewModel.review.userInfo?.username ?? "null")
                Text(viewModel.review.timestamp.getFormattedDate())
                
            }
            
            HStack
            {
                if viewModel.review.likedUsers.contains(UserInfo.shared.user!.uid)
                {
                    DisLikeButton(islikeProcessing: $viewModel.isLikeProcessing, disLikeReview: viewModel.unLikeReview)
                }
                else
                {
                    LikeButton(islikeProcessing: $viewModel.isLikeProcessing, likeReview: viewModel.likeReview)
                }
                
                Spacer()
                
                NavigationLink(value: viewModel.review.firmInfo!) {
                    Text(viewModel.review.firmInfo?.name ?? "null")
                }
                
            }
            .padding(.init(top: 5, leading: 10, bottom: 0, trailing: 10))
            
            
            
            
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        })
        .frame(width: 300,height: 500)
        .background(Color(.systemBackground))
        .overlay(alignment : .topTrailing) {
            Button(action: {
                isShowingDetail = false
                
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20,height: 20)
                    .bold()
                    .padding(.top , 10)
                    .padding(.trailing,10)
            })
        }
        .cornerRadius(15)
        .shadow(radius: 40)
        
        
    }
    
}

#Preview {
    ReviewDetailView(review: Review.sampleReview, isShowingDetail: .constant(true))
    
}


struct LikeButton: View {
    @Binding var islikeProcessing : Bool
    var likeReview : () -> Void
    var body: some View {
        Button("Like", systemImage: "hand.thumbsup.fill") {
            likeReview()
        }
        .disabled(islikeProcessing)
    }
}

struct DisLikeButton: View {
    @Binding var islikeProcessing : Bool
    var disLikeReview : () -> Void
    var body: some View {
        Button("Unlike", systemImage: "hand.thumbsdown.fill") {
            disLikeReview()
        }
        .disabled(islikeProcessing)
        .tint(Color(.red))
    }
}

#Preview {
    LikeButton(islikeProcessing: .constant(false)) {
        
    }
    
}
