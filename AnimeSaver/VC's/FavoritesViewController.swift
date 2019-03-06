//
//  FavoritesViewController.swift
//  AnimeSaver
//
//  Created by Jason on 3/6/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var favorties = "" {
        didSet{
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
    }
    
    

    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
