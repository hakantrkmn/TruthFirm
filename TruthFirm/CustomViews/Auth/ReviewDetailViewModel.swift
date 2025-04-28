//
//  ReviewDetailViewModel.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 8.09.2024.
//

import Foundation
import SwiftUI
@MainActor
class ReviewDetailViewModel : ObservableObject
{
    //@Published var review : Review
    @Published var isLikeProcessing = false
    @Published var alertItem : AlertItem?
//    init(review: Review) {
//            self.review = review
//        
//        }
    
    func likeReview(review : Review) async throws -> Review?
    {
            isLikeProcessing = true
            var likedReview: Review? = nil
            do{
                try await DBService.likeReview(review: review) { result in
                    switch result {
                    case .success(let success):
                        likedReview = success
                    case .failure(let failure):
                        self.alertItem = failure
                    }
                }
                UserInfo.shared.user?.likedReviews.append(review.id!)
            }
            catch let err
            {
                alertItem = AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))
            }
            isLikeProcessing = false
            return likedReview
    }
    
    func unLikeReview(review : Review) async throws -> Review?
    {
            isLikeProcessing = true
            var dislikedReview: Review? = nil
            do{
                try await DBService.unLikeReview(review: review) { result in
                    switch result {
                    case .success(let success):
                        dislikedReview = success
                    case .failure(let failure):
                        self.alertItem = failure
                    }
                }
                UserInfo.shared.user?.likedReviews.removeAll(where: { str in
                    str == review.id
                })
            }
            catch let err
            {
                alertItem = AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))
            }
            isLikeProcessing = false
            return dislikedReview
    }
}
