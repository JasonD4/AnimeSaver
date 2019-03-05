//
//  MyNetworkHelper.swift
//  AnimeSaver
//
//  Created by Jason on 2/21/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

final class MyNetworkHelper{
    
    static func updateFromName(keyword: String, complete: @escaping ([AnimeAttributes]) -> Void ){
        var anime = [AnimeAttributes]()
        
        loadingData(keyword: keyword, escapee: { (data) in
            
            
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

    static func updateFromCatagory(keyword: String, complete: @escaping ([AnimeAttributes]) -> Void ){
    var anime = [AnimeAttributes]()
    
    loadingDataByCatagory(keyword: keyword, escapee: { (data) in
        
        
        do{
            let AllAnime = try JSONDecoder().decode(AnimeFound.self, from: data)
            anime = AllAnime.data
            complete(anime)
            print(anime.count)
        }catch{
            print("error is: \(error)")
        }
    })
    
}





private static func loadingData(keyword: String,escapee: @escaping (Data) -> Void){
    guard let myURL = URL.init(string: "https://kitsu.io/api/edge/anime?filter[text]=\(keyword)") else {return}
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

private static func loadingDataByCatagory (keyword: String, escapee: @escaping (Data) -> Void){
    guard let myURL = URL.init(string: "https://kitsu.io/api/edge/anime?filter[genres]=\(keyword)") else {return}
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
    
    static func youtubeVidLoader(videoCode: String) -> URLRequest{
        var urlGotten: URLRequest!
        if let url = URL(string: "https://www.youtube.com/embed/\(videoCode)"){
           urlGotten = URLRequest(url: url)
        }
        return urlGotten
}

}
