//
//  AVHelper.swift
//  AnimeSaver
//
//  Created by Jason on 3/11/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AVHelper{
    private init (){}
    
  private static var player: AVAudioPlayer?
    
    static func playMusic(){
    guard let path = Bundle.main.url(forResource: "Bestofbestest", withExtension: ".mp3") else{
        return
        }
    
    do{
    player = try AVAudioPlayer.init(contentsOf: path)
    guard let musicPlayer = player else {return}
    musicPlayer.play()
    }catch{
        print("error:   ")
    print(error.localizedDescription)
    }
}
}

