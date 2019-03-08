//
//  FavoriteDetalViewController.swift
//  AnimeSaver
//
//  Created by Jason on 3/6/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class FavoriteDetalViewController: UIViewController {
    
    var reviewInfo: AnimeFirebaseModel!

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var animeName: UILabel!
    @IBOutlet weak var reviewerReview: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupValues()
    }
    
    func setupValues(){
        if let url = URL(string: reviewInfo.image){
            
            UrlToImage.urlIntoData(url: url) { (image) in
                
                self.picture.image = image
                
                }
        }
        animeName.text = reviewInfo.animeName
        reviewerReview.text = reviewInfo.userReview
    }


}
