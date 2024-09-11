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
    @Published var review : Review
    @Published var isLikeProcessing = false
    @Published var alertItem : AlertItem?
    init(review: Review) {
            self.review = review
        }
    
    func likeReview()
    {
        Task{
            isLikeProcessing = true
            do{
                try await DBService.likeReview(review: review) { result in
                    switch result {
                    case .success(let success):
                        self.review = success
                    case .failure(let failure):
                        self.alertItem = failure
                    }
                }
            }
            catch let err
            {
                alertItem = AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))
            }
            isLikeProcessing = false
        }
    }
    
    func unLikeReview()
    {
        Task{
            isLikeProcessing = true
            do{
                try await DBService.unLikeReview(review: review) { result in
                    switch result {
                    case .success(let success):
                        self.review = success
                    case .failure(let failure):
                        self.alertItem = failure
                    }
                }
            }
            catch let err
            {
                alertItem = AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))
            }
            isLikeProcessing = false
        }
    }
}
