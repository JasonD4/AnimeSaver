//
//  ProfileViewController.swift
//  AnimeSaver
//
//  Created by Jason on 3/5/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var userSession: UserSession!
    private var storageModel: StorageManager!
    private var picHolder = ["Neptune3", "Noire3", "Blanc3"]
    private lazy var pickerImage: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        return imagePicker
    }()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        profileImageButton.setImage(UIImage.init(named: picHolder.randomElement()!), for: .normal)
            userSession = (UIApplication.shared.delegate as! AppDelegate).usersession
            storageModel = (UIApplication.shared.delegate as! AppDelegate).storageManager
        
     
            
            // set the delegate for sign out
            userSession.usersessionSignOutDelegate = self
            storageModel.delegate = self
        

            // set email label
            guard let user = userSession.getCurrentUser() else {
                emailLabel.text = "no logged user"

                return
            }
            emailLabel.text = user.email ?? "no email found for logged user"
            
            guard let photoURL = user.photoURL else {
                print("no photoURL")
                return
            }
            if let image = ImageCache.shared.fetchImageFromCache(urlString: photoURL.absoluteString) {
                profileImageButton.setImage(image, for: .normal)
            } else {
                ImageCache.shared.fetchImageFromNetwork(urlString: photoURL.absoluteString) { (appError, image) in
                    if let appError = appError {
                        self.showAlert(title: "Fetching Image Error", message: appError.errorMessage(), actionTitle: "Ok")
                    } else if let image = image {
                        self.profileImageButton.setImage(image, for: .normal)
                    }
                }
            }
        }
    
    @IBAction func signOut(_ sender: UIButton){
            userSession.signOut()
    }
    
    @IBAction func photoPicture(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.pickerImage.sourceType = .camera
            self.showImagePickerController()
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.pickerImage.sourceType = .photoLibrary
            self.showImagePickerController()
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true)
    }
    
    private func showImagePickerController() {
        present(pickerImage, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UserSessionSignOutDelegate{
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Sign Out Error", message: error.localizedDescription, actionTitle: "Ok")
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        presentLoginViewController()
    }
    
    private func presentLoginViewController() {
        if let _ = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UITabBarController {
            // coming from existing sign in state (tab bar controller is rootViewController)
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "test")
            window?.rootViewController = loginViewController
        } else {
            // coming from new login state (login view controller is rootViewController)
            dismiss(animated: true)
        }
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error with Image", message: "Try Again", actionTitle: "Ok")
            return
        }
        profileImageButton.setImage(originalImage, for: .normal)
        
        // convert the image to Data for posting to Firebase Storage
        guard let imageData = originalImage.jpegData(compressionQuality: 0.5) else {
            print("failed to create data from image")
            return
        }
        // save the image to Firebase Storage
        storageModel.postImage(withData: imageData)
        
        dismiss(animated: true)
    }
}

extension ProfileViewController: StorageManagerDelegate {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL) {
        // update the auth user's photoURL
        userSession.updateUser(displayName: nil, photoURL: imageURL)
    }
}
