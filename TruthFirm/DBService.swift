//
//  DBService.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 8.09.2024.
//
import SwiftUI
import Foundation
import Firebase
@MainActor
class DBService
{
    static let db = Firestore.firestore()

    static func likeReview(review : Review , completionHandler : @escaping (Result<Review,AlertItem>) -> Void) async throws {
        
        let usersRef = db.collection("users")

        let querySnapshot = usersRef.document(UserInfo.shared.user!.uid)
        
        try await querySnapshot.updateData(["likedReviews" : FieldValue.arrayUnion([review.id!])])
        
        
        let reviewRef = db.collection("reviews")
        let reviewSnapShot = reviewRef.document(review.id!)

        try await reviewSnapShot.updateData(["likedUsers" : FieldValue.arrayUnion([UserInfo.shared.user!.uid])])
        
        
        let newRev = try await reviewSnapShot.getDocument(as: Review.self)
        try await getUserInfo(userID: newRev.userId) { result in
            switch result {
            case .success(let success):
                newRev.userInfo = success
            case .failure(let failure):
                completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(failure.localizedDescription), dismissButton: .default(Text("OK")))))
            }
        }
        
        try await getFirmInfo(firmID: newRev.firmId) { result in
            switch result {
            case .success(let success):
                newRev.firmInfo = success
            case .failure(let failure):
                completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(failure.localizedDescription), dismissButton: .default(Text("OK")))))
            }
        }
        

        completionHandler(.success(newRev))
        

    }
    
    static func unLikeReview(review : Review ,completionHandler : @escaping (Result<Review,AlertItem>) -> Void) async throws {
        
        let usersRef = db.collection("users")

        let querySnapshot = usersRef.document(UserInfo.shared.user!.uid)
        
        try await querySnapshot.updateData(["likedReviews" : FieldValue.arrayRemove([review.id!])])
        
        
        let reviewRef = db.collection("reviews")
        let reviewSnapShot = reviewRef.document(review.id!)

        try await reviewSnapShot.updateData(["likedUsers" : FieldValue.arrayRemove([UserInfo.shared.user!.uid])])

        let newRev = try await reviewSnapShot.getDocument(as: Review.self)
        
        try await getUserInfo(userID: newRev.userId) { result in
            switch result {
            case .success(let success):
                newRev.userInfo = success
            case .failure(let failure):
                completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(failure.localizedDescription), dismissButton: .default(Text("OK")))))
            }
        }
        
        try await getFirmInfo(firmID: newRev.firmId) { result in
            switch result {
            case .success(let success):
                newRev.firmInfo = success
            case .failure(let failure):
                completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(failure.localizedDescription), dismissButton: .default(Text("OK")))))
            }
        }
        
        completionHandler(.success(newRev))

        

    }
    
    static func getFirmInfo(firmID : String , completionHandler : @escaping (Result<FirmModel,AlertItem>) -> Void) async throws
    {
        do {
            let snapshot = db.collection("firms").document(firmID)
            let firm  = try await snapshot.getDocument(as: FirmModel.self)
            completionHandler(.success(firm))
        } catch  let err{
            completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))))
        }
        
    }
    
    static func getUserInfo(userID : String , completionHandler : @escaping (Result<UserModel,AlertItem>) -> Void) async throws
    {
        do {
            let snapshot = db.collection("users").document(userID)
            let user  = try await snapshot.getDocument(as: UserModel.self)
            completionHandler(.success(user))
        } catch  let err{
            completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))))
        }
        
    }
    
    static func getReview(reviewID : String , completionHandler : @escaping (Result<Review,AlertItem>) -> Void) async throws
    {
        do {
            let snapshot = db.collection("reviews").document(reviewID)
            let review  = try await snapshot.getDocument(as: Review.self)
            try await getUserInfo(userID: review.userId, completionHandler: { result in
                switch result {
                case .success(let success):
                    review.userInfo = success
                case .failure(let failure):
                    completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(failure.localizedDescription), dismissButton: .default(Text("OK")))))
                }
            })
            
            try await getFirmInfo(firmID: review.firmId) { result in
                switch result {
                case .success(let success):
                    review.firmInfo = success
                case .failure(let failure):
                    completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(failure.localizedDescription), dismissButton: .default(Text("OK")))))
                }
            }
            
            completionHandler(.success(review))
        } catch  let err{
            completionHandler(.failure(AlertItem(title: Text("Error"), message: Text(err.localizedDescription), dismissButton: .default(Text("OK")))))
        }
        
    }
}

@MainActor
struct AlertItem : Identifiable , Error{
    let id = UUID()
    let title: Text
    let message : Text
    let dismissButton : Alert.Button
}
