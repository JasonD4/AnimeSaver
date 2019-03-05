//
//  AnimeFirebaseModel.swift
//  AnimeSaver
//
//  Created by Jason on 2/26/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import CoreLocation

struct AnimeFirebaseModel {
    let animeName: String
    let userReview: String
    let catagory: String
    let image: String
    let userId: String
    let AnimeId: String
    let episode: Int
    
    init(animeName: String,userReview: String, catagory: String ,image: String ,userId: String, AnimeId: String, episode: Int){
        self.animeName = animeName
        self.userReview = userReview
        self.catagory = catagory
        self.image = image
        self.userId = userId
        self.AnimeId = AnimeId
        self.episode = episode
    }
    init(dict: [String: Any]) {
        self.animeName = dict["animeName"] as? String ?? "no anime name"
        self.userReview = dict["userReview"] as? String ?? "no User review"
        self.catagory = dict["catagory"] as? String ?? "other"
        self.image = dict["image"] as? String ?? ""
        self.userId = dict["userId"] as? String ?? "No User Log in"
        self.AnimeId = dict["AnimeId"] as? String ?? "no AnimeId"
        self.episode = dict["episode"] as? Int ?? 0
        
    }
}
