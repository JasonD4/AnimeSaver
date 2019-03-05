//
//  ViewController.swift
//  AnimeSaver
//
//  Created by Jason on 2/7/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AnimeViewController: UIViewController {

    @IBOutlet weak var animeSearchBar: UISearchBar!
     
    @IBOutlet weak var animeCollectionView: UICollectionView!
    
    var anime = [AnimeAttributes](){
        didSet{
            DispatchQueue.main.async {
            self.animeCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewDidLoadSetup()
    }

    func viewDidLoadSetup(){
        MyNetworkHelper.updateFromName(keyword: "Naruto", complete: { (animes) in
           self.anime = animes
        })
        animeCollectionView.dataSource = self
        animeCollectionView.delegate = self
        animeSearchBar.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = animeCollectionView.indexPathsForSelectedItems,
            let animeDVC = segue.destination as? AnimeDetailViewController else {return}
        animeDVC.animeOfIntrestADV = anime[indexPath[0].row]
    }
    
    @IBAction func login(_ sender: UIBarButtonItem) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "LoginVC")
//        self.present(vc, animated: true)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension AnimeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = animeCollectionView.dequeueReusableCell(withReuseIdentifier: "AnimeCell", for: indexPath) as? AnimeCell else{return UICollectionViewCell()}
        
        
        if anime[indexPath.row].attributes.posterImage.original == nil{
            collectionCell.animePic.image = UIImage(contentsOfFile: "Neptune3")
        }
        
        UrlToImage.urlIntoData(url: anime[indexPath.row].attributes.posterImage.original!) { (image) in
            collectionCell.animePic.image = image
        }
        
        collectionCell.animeName.text = anime[indexPath.row].attributes.canonicalTitle
        
        
        return collectionCell
    }
    
    
}

extension AnimeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animeDetailVC = PreviewViewContoller()
        animeDetailVC.animeOfIntrest = anime[indexPath.row]

        

    
}
}

// good to go SearchBar
extension AnimeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
        print(text)
        MyNetworkHelper.updateFromCatagory(keyword: text) { (anime) in
            if anime.isEmpty{
                MyNetworkHelper.updateFromName(keyword: text, complete: { (anime) in
                    if anime.isEmpty{
                        let alert = UIAlertController.init(title: "Error", message: "No Anime Found", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }else{
                        self.anime = anime
                    }
                })
            }else{
                self.anime = anime
            }
        }
        searchBar.resignFirstResponder()
    }
        else{ let alert = UIAlertController.init(title: "Error", message: "Invalid Request", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            present(alert, animated: true)
            
        }
}

}

