//
//  AnimeDetailViewController.swift
//  AnimeSaver
//
//  Created by Jason on 2/11/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import WebKit


class PreviewViewContoller: UIViewController {
    
    @IBOutlet weak var animeWebView: WKWebView!
    
    
    var animeOfIntrest: AnimeAttributes?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animeWebView.load(MyNetworkHelper.youtubeVidLoader(videoCode: (animeOfIntrest?.attributes.youtubeVideoId ?? "sTSA_sWGM44")))
        
    }
    
    

}
