//
//  ReviewViewController.swift
//  AnimeSaver
//
//  Created by Jason on 3/6/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var animeImgae: UIImageView!
    @IBOutlet weak var Review: UITextView!
    
    var anime: AnimeAttributes?
    private var userSession: UserSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        userSession = (UIApplication.shared.delegate as! AppDelegate).usersession

        UrlToImage.urlIntoData(url: anime!.attributes.posterImage.original!) { (image) in
            
            self.animeImgae.image = image
            
        }
        
    }
    
    
    @IBAction func saveTriggered(_ sender: UIButton) {
        guard let user = userSession.getCurrentUser() else{return}
        if Review.text.isEmpty{
            let alert = UIAlertController(title: "Invalid Review", message: "Please Enter a Valid Review", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            present(alert, animated: true)
        }else{
            let animeSave = AnimeFirebaseModel.init(animeName: anime?.attributes.canonicalTitle ?? "", userReview: Review.text, image: anime?.attributes.posterImage.original?.absoluteString ?? "", userId: user.uid, AnimeId: anime?.id ?? "", episode: anime?.attributes.episodeCount ?? 0, lore: anime?.attributes.synopsis ?? "", userName: userSession.getCurrentUser()?.email ?? "", lastSearchTerm: nil)
            DataBaseManager.postAnimeReview(animeRview: animeSave)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
}
