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
        setting.areTimestampsInSnapshotsEnabled = true
        db.settings = setting
        return db
    }()
}
