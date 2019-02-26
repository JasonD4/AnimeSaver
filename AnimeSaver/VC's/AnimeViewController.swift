//
//  ViewController.swift
//  AnimeSaver
//
//  Created by Jason on 2/7/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

public var animeWanted = "naruto"


class AnimeViewController: UIViewController {

    
    @IBOutlet weak var AnimeCollectionView: UICollectionView!
    
    
    var anime = [AnimeAttributes](){
        didSet{
            DispatchQueue.main.async {
            self.AnimeCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSetup()
    }

    func viewDidLoadSetup(){
        MyNetworkHelper.update { (animes) in
           self.anime = animes
        }
        AnimeCollectionView.dataSource = self
        AnimeCollectionView.delegate = self
    }
}


extension AnimeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = AnimeCollectionView.dequeueReusableCell(withReuseIdentifier: "AnimeCell", for: indexPath) as? AnimeCell else{return UICollectionViewCell()}
        
        
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
        " "
    }
    
}
extension AnimeViewController: UISearchBarDelegate{
    
}
