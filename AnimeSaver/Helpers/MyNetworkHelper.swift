//
//  MyNetworkHelper.swift
//  AnimeSaver
//
//  Created by Jason on 2/21/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import UIKit

final class MyNetworkHelper{
    
    static func update(complete: @escaping ([AnimeAttributes]) -> Void ){
        var anime = [AnimeAttributes]()
        
        loadingData(escapee: { (data) in
            
            
            do{
                let AllAnime = try JSONDecoder().decode(AnimeFound.self, from: data)
                anime = AllAnime.data
                complete(anime)
                print(anime.count)
            }catch{
                print("error is: \(error)")
            }
        })
        //        return anime
        
    }
}




func loadingData (escapee: @escaping (Data) -> Void){
    guard let myURL = URL.init(string: "https://kitsu.io/api/edge/anime?filter[text]=\(animeWanted)") else {return}
    // this is just the link
    URLSession.shared.dataTask(with: myURL) { (data, response, error) in
        // these 3 are variables
        if let response = response {
            print(response)
        }
        if let error = error{
            print(error)
            //if url failed
        }
        if let data = data{
            escapee(data)
            // at the end of all the closer u must do .resume()
            
        }
        
        }.resume()
}
