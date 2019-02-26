//
//  File.swift
//  AnimeSaver
//
//  Created by Jason on 2/21/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import Foundation
import UIKit

final class UrlToImage{
    
    static func urlIntoData(url: URL, completion: @escaping (UIImage) -> Void)  {
        let newURL = url
        
        do{
            let data = try Data(contentsOf: newURL)
            if let image = UIImage.init(data: data){
                completion(image)
            }
        }
        catch{
            print(error)
        }
    }
    
    
    
    
    
    
}
