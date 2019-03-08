//
//  PreviewViewController.swift
//  AnimeSaver
//
//  Created by Jason on 2/21/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import FirebaseAuth

class AnimeDetailViewController: UIViewController {
    var animeOfIntrestADV: AnimeAttributes?
    
    @IBOutlet weak var preview: UIButton!
    @IBOutlet weak var pictureOfSaidAnime: UIImageView!
    @IBOutlet weak var startToEndDate: UILabel!
    @IBOutlet weak var episodeLength: UILabel!
    @IBOutlet weak var statusAndNextRelease: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var japaneseName: UILabel!
    @IBOutlet weak var summaryOfSaidAnime: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTheAnimeInfoAnime()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ((segue.destination as? ReviewViewController) != nil){
            if Auth.auth().currentUser == nil{
             let alert =  UIAlertController(title: "Problem", message: "Please log in", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
            }else{
        guard let reviewVC = segue.destination as? ReviewViewController else{return}
        reviewVC.anime = animeOfIntrestADV
            }
            } else {
       guard let animeDVC = segue.destination as? PreviewViewContoller else {return}
                animeDVC.animeOfIntrest = self.animeOfIntrestADV
        }
    }
    

}

extension AnimeDetailViewController{
    private func getTheAnimeInfoAnime(){
        
        self.title = animeOfIntrestADV?.attributes.canonicalTitle
        
        UrlToImage.urlIntoData(url: animeOfIntrestADV!.attributes.posterImage.original!) { (image) in
            
            self.pictureOfSaidAnime.image = image
            
        }
        
        startToEndDate.text = "Start Date: \(animeOfIntrestADV?.attributes.startDate ?? "Not released yet") - End Date: \(animeOfIntrestADV?.attributes.endDate ?? "Still Going")"
        
        episodeLength.text = "EpisodeLength: \(animeOfIntrestADV?.attributes.episodeLength ?? 0)Mins"
        
        if animeOfIntrestADV?.attributes.nextRelease == nil{
            
            statusAndNextRelease.text = "This Anime is finished"
        }
        else{
            statusAndNextRelease.text = "Next Episode Release Date: \(animeOfIntrestADV?.attributes.nextRelease ?? "")"
        }
        
        
        if animeOfIntrestADV?.attributes.nsfw == true{
            
            ageRating.text = "\(animeOfIntrestADV?.attributes.ageRating ?? "") \(animeOfIntrestADV?.attributes.ageRatingGuide ?? "") I wouldnt recommend to watch this at work"
            
        }
        else{ ageRating.text = "\(animeOfIntrestADV?.attributes.ageRating ?? "") \(animeOfIntrestADV?.attributes.ageRatingGuide ?? "") This is safe to watch at the work"
        }
        
        if animeOfIntrestADV?.attributes.ja_jp == nil{
            japaneseName.text = "Same as English"
        }
        else{
            japaneseName.text = "japanese name: \(animeOfIntrestADV?.attributes.ja_jp ?? "")"
            
            
        }
        summaryOfSaidAnime.text =  animeOfIntrestADV?.attributes.synopsis ?? ""
        
    }
}
