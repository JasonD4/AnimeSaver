//
//  FavoritesViewController.swift
//  AnimeSaver
//
//  Created by Jason on 3/6/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class FavoritesViewController: UIViewController {
    
    var favorties = [AnimeFirebaseModel]() {
        didSet{
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
    }
    private var listener: ListenerRegistration!
    private var userSession: UserSession!

    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userSession = (UIApplication.shared.delegate as! AppDelegate).usersession
//        favoriteTableView.dataSource = self
//        favoriteTableView.delegate = self
//        viewSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userSession = (UIApplication.shared.delegate as! AppDelegate).usersession
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        viewSetup()

    }
    
    func viewSetup(){
        favorties.removeAll()
        if let user = userSession.getCurrentUser(){
            title = user.email
                listener = DataBaseManager.firebaseDB.collection(DatabaseKeys.userCollectionReviewsKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .cancel))
                        self.present(alert, animated: true)
                    } else if let snapshot = snapshot {
                        var reviews = [AnimeFirebaseModel]()
                        for document in snapshot.documents{
                            let animeReviews = AnimeFirebaseModel(dict: document.data())
                            reviews.append(animeReviews)

                    }
                        self.favorties = reviews.filter(){$0.userName == $0.userName}
                }
            }
           // let info = Storage.storage().
//print(info)
            
            
        }else{
         let alert = UIAlertController(title: "User is not logged in", message: "Please log in to view comments", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            guard let favDVC = segue.destination as? FavoriteDetalViewController,
                let indexpath = favoriteTableView.indexPathForSelectedRow else {return}
        
            favDVC.reviewInfo = favorties[indexpath.row]
        }

}

extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "Favorite", for: indexPath) as? FavoritesTableViewCell else{ return UITableViewCell()}
        
        if let url = URL(string: favorties[indexPath.row].image){
        
        UrlToImage.urlIntoData(url: url) { (image) in
            
            cell.animePicture.image = image
            
            }
        }
        cell.userName.text = favorties[indexPath.row].userName
        cell.nameOfAnime.text = favorties[indexPath.row].animeName
        return cell
    }
    
    
}

extension FavoritesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(300)
    }
}
