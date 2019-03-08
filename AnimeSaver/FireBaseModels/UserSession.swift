//
//  UserSession.swift
//  AnimeSaver
//
//  Created by Jason on 2/28/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserSessionAccountCreationDelegate: AnyObject {
    func didCreateAccount(_ userSession: UserSession, user: User)
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error)
}

protocol UserSessionSignOutDelegate: AnyObject {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error)
    func didSignOutUser(_ usersession: UserSession)
}

protocol UserSessionSignInDelegate: AnyObject {
    func didRecieveSignInError(_ usersession: UserSession, error: Error)
    func didSignInExistingUser(_ usersession: UserSession, user: User)
}

final class UserSession{
    weak var userSessionAccountDelegate: UserSessionAccountCreationDelegate?
    weak var usersessionSignOutDelegate: UserSessionSignOutDelegate?
    weak var usersessionSignInDelegate: UserSessionSignInDelegate?
    
    public func createNewUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error{
                self.userSessionAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
            } else if let data = data{
                guard let username = data.user.email?.components(separatedBy: "@").first else{
                    print("Not a valid Email")
                    return
                }
                DataBaseManager.firebaseDB.collection(DatabaseKeys.userCollectionKey).document(data.user.uid.description).setData(["userId" : data.user.uid,
                    "userEmail" : data.user.email ?? "",
                    "displayName" : data.user.displayName ?? "",
                    "imageURL": data.user.photoURL ?? "",
                    "userName": username],                                                                                         completion: { (error) in
                        if let error = error {
                            print("error adding authenticated user to the database: \(error)")
                            
                        }else{
                            
                        }
                })
                
            }
        }
    }
    
    public func getCurrentUser() -> User?{
        return Auth.auth().currentUser
    }
    
    public func signInWithExsistingUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error{
                self.usersessionSignInDelegate?.didRecieveSignInError(self, error: error)
            } else if let data = data{
                self.usersessionSignInDelegate?.didSignInExistingUser(self, user: data.user)
            }
        }
        
    }
    public func signOut(){
        guard let _ = getCurrentUser() else{
            print("not logged in")
            return
        }
        do{
            try Auth.auth().signOut()
            usersessionSignOutDelegate?.didSignOutUser(self)
        }catch{
            usersessionSignOutDelegate?.didRecieveSignOutError(self, error: error)
        }
    }
    
    public func updateUser(displayName: String?, photoURL: URL?) {
        guard let user = getCurrentUser() else {
            print("no logged user")
            return
        }
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        request.photoURL = photoURL
        request.commitChanges { (error) in
            if let error = error {
                print("error: \(error)")
            } else {
                // update database user as well
                guard let photoURL = photoURL else {
                    print("no photoURL")
                    return
                }
                DataBaseManager.firebaseDB
                    .collection(DatabaseKeys.userCollectionKey)
                    .document(user.uid) // making the user document id the same as the auth userId makes it easy to update the user doc
                    .updateData(["imageURL": photoURL.absoluteString], completion: { (error) in
                        guard let error = error else {
                            print("successfully ")
                            return
                        }
                        print("updating photo url error: \(error.localizedDescription)")
                        
                    })
            }
        }
    }

}

