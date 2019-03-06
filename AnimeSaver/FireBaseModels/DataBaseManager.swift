//
//  DataBaseManager.swift
//  AnimeSaver
//
//  Created by Jason on 2/28/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DataBaseManager{
    private init () {}
    
    static let firebaseDB: Firestore = {
        let db = Firestore.firestore()
        let setting = db.settings
        db.settings = setting
        return db
    }()
    
    static func postAnimeReview(animeRview: AnimeFirebaseModel) {
        firebaseDB.collection(DatabaseKeys.userCollectionReviewsKey).document(animeRview.userId.description).setData([
            "animeName"    : animeRview.animeName,
            "userReview"  : animeRview.userReview,
            "image"  : animeRview.image,
            "userId"    : animeRview.userId,
            "AnimeId"   : animeRview.AnimeId,
            "episode"    : animeRview.episode,
            "lore"  : animeRview.lore,
            "lastSearchTerm": animeRview.lastSearchTerm ?? ""
            ], completion: { (error) in
                if let error = error {
                    print("posing race failed with error: \(error)")
                } else {

                }
        })
    }
}
