//
//  StreamModel.swift
//  AnimeSaver
//
//  Created by Jason on 2/21/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let email: String
    let username: String
    
    init(email: String, username: String){
        self.email = email
        self.username = username
    }
    init(dict: [String: Any]){
        self.email = dict["email"] as? String ?? "No Email"
        self.username = dict["username"] as? String ?? "No Username"
    }
}
