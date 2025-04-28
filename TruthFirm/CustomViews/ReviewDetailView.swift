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
    @Binding var choosedReview : Review
    init(isShowingDetail : Binding<Bool>,choosenReview : Binding<Review>) {
        _viewModel = StateObject(wrappedValue: ReviewDetailViewModel())
        _isShowingDetail = isShowingDetail
        _choosedReview = choosenReview
        
    }
    var body: some View {
        VStack{
            ScrollView{
                Text(choosedReview.reviewText)
            }
            .padding()
            .frame(width: 300, height: 400)
            
            HStack{
                Text(choosedReview.userInfo?.username ?? "null")
                Text(choosedReview.timestamp.getFormattedDate())
                
            }
            
            HStack
            {
                if choosedReview.likedUsers.contains(UserInfo.shared.user!.uid)
                {
                    DisLikeButton(islikeProcessing: $viewModel.isLikeProcessing, review: $choosedReview, disLikeReview: viewModel.unLikeReview(review:))
                }
                else
                {
                    LikeButton(islikeProcessing: $viewModel.isLikeProcessing, likeReview: viewModel.likeReview(review:), review: $choosedReview)
                }
                
                Spacer()
                
                NavigationLink(value: choosedReview.firmInfo!) {
                    Text(choosedReview.firmInfo?.name ?? "null")
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

    ReviewDetailView( isShowingDetail: .constant(false), choosenReview: .constant(.sampleReview))
}


struct LikeButton: View {
    @Binding var islikeProcessing : Bool
    var likeReview : (Review) async throws -> Review?
    @Binding var review : Review
    var body: some View {
        Button("Like", systemImage: "hand.thumbsup.fill") {
            Task {
                let result = try await likeReview(review)
                if let updatedReview = result {
                    review = updatedReview
                }
            }
        }
        .disabled(islikeProcessing)
    }
}

struct DisLikeButton: View {
    @Binding var islikeProcessing : Bool
    @Binding var review : Review
    var disLikeReview : (Review) async throws->  Review?
    var body: some View {
        Button("Unlike", systemImage: "hand.thumbsdown.fill") {
            Task {
                let result = try await disLikeReview(review)
                if let updatedReview = result {
                    review = updatedReview
                }
            }
        }
        .disabled(islikeProcessing)
        .tint(Color(.red))
    }
}

